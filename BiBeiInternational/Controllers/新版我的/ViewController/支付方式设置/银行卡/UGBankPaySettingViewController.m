//
//  UGBankPaySettingViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBankPaySettingViewController.h"
#import "UGButton.h"
#import "UGBindBankPayApi.h"
#import "UGSeletedBankVC.h"
#import "UGGetBankNoApi.h"
#import "UGGetBankInfoByNoApi.h"
#import "UGGetBankInfoModel.h"
#import "PictureCroppingVC.h"
#import "EditPhotoVC.h"
#import <Photos/Photos.h>
#import "UGCheckMemberOtcOrderApi.h"

@interface UGBankPaySettingViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UGButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *bankTF;
@property (weak, nonatomic) IBOutlet UITextField *branchTF;
@property (weak, nonatomic) IBOutlet UITextField *carNoTF;
@property (weak, nonatomic) IBOutlet UITextField *rCarNoTF;
@property (weak, nonatomic) IBOutlet UITextField *jypasswordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jyContinerHeight;
@property (weak, nonatomic) IBOutlet UIView *jyContinerView;

@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;

@property (nonatomic,assign)BOOL isEditing;
@property (nonatomic,assign)BOOL  hasBinded;

@property (nonatomic,strong)UGGetBankInfoModel *infoModel;

@property (weak, nonatomic) IBOutlet UIView *topAlertView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAlertViewTopHeight;

@end

@implementation UGBankPaySettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //避免前面获取数据失败获取不到姓名
    self.nameTF.text = [UGManager shareInstance].hostInfo.userInfoModel.application.realName;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : HEXCOLOR(0x333333),
    NSFontAttributeName : [UIFont systemFontOfSize:18]}];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"银行卡设置";
    self.confirmButton.buttonStyle = UGButtonStyleBlue;
    if (self.updateBind) {
        @weakify(self);
        [self setupBarButtonItemWithTitle:@"编辑" type:UGBarImteTypeRight titleColor:HEXCOLOR(0x333333) callBack:^(UIBarButtonItem * _Nonnull item) {@strongify(self);
            [self chageViewsStauts:!self.confirmButton.hidden];
            [self.view endEditing:YES];
            if ([[item.customView titleForState:UIControlStateNormal] isEqualToString:@"编辑"]) {
                [item.customView setTitle:@"取消" forState:UIControlStateNormal];
            }else{
                [item.customView setTitle:@"编辑" forState:UIControlStateNormal];
            }
            
        }];
        [self showTextFieldDefault:YES];
    }
    //姓名取实名认证的姓名且不能修改
    self.nameTF.text = [UGManager shareInstance].hostInfo.userInfoModel.application.realName;
    //普通用户隐藏提醒
    if (![self isCardVip]) {
        self.topAlertView.hidden = YES;
        self.topAlertViewTopHeight.constant = 0;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedBankInfo:) name:@"选择银行名称" object:nil];
}

#pragma mark -delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制输入emoji表情
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([NSString isNineKeyBoard:string] ){
        return YES;
    }else{
        if ([NSString hasEmoji:string] || [NSString stringContainsEmoji:string]){
            return NO;
        }
    }
    return YES;
}

-(void)selectedBankInfo:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSString *bandName = [useInfo objectForKey:@"bandName"];
    if (!UG_CheckStrIsEmpty(bandName)) {
        self.bankTF.text = bandName;
    }
}

#pragma mark - 选择开户行
- (IBAction)selectedBank:(id)sender {
//    [self.navigationController pushViewController:[UGSeletedBankVC new] animated:YES];
//    @weakify(self);
//    [self showTakePhotoChooseWithMaxCount:1 WithPoto:YES handle:^(NSArray<UIImage *> * _Nonnull imageList) {
//        @strongify(self);
//        if (imageList.count > 0) {
//            [self uploadImageReuest:imageList.firstObject];
//        }
//    }];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
         @weakify(self);
        UIAlertAction *takePhotoAction =[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            EditPhotoVC *takePhotoVC = [[EditPhotoVC alloc]init];
            takePhotoVC.isIDCard = NO;
            takePhotoVC.imageblock = ^(UIImage * _Nonnull image) {
                @strongify(self);
                [self uploadImageReuest:image];
            };
            
            [self.navigationController pushViewController:takePhotoVC animated:YES];
            
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted ||
                status == PHAuthorizationStatusDenied) {
                NSString *errorStr;
                NSString *okStr;
                errorStr =@"应用访问相册权限受限,请您前往设置中启用。";
                okStr = @"我知道了";
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleCancel handler:nil];
                [alertCtl addAction:cancelAction];
                [self presentViewController:alertCtl animated:YES completion:nil];
            }
            else
            {
                UIImagePickerController *vc = [[UIImagePickerController alloc] init];
                vc.delegate = self;
                vc.allowsEditing = NO;
                vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                vc.modalPresentationStyle =  UIModalPresentationFullScreen;
            
                [self presentViewController:vc animated:YES completion:nil];
            }
        }];
        UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCtl addAction:takePhotoAction];
        [alertCtl addAction:albumAction];
        [alertCtl addAction:canelAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
        
    }
    else
    {
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *takePhotoAction =[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            EditPhotoVC *takePhotoVC = [[EditPhotoVC alloc]init];
            takePhotoVC.isIDCard = YES;
            takePhotoVC.imageblock = ^(UIImage * _Nonnull image) {
                [self uploadImageReuest:image];
            };
            
            [self.navigationController pushViewController:takePhotoVC animated:YES];
            
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted ||
                status == PHAuthorizationStatusDenied) {
                NSString *errorStr;
                NSString *okStr;
                errorStr =@"应用访问相册权限受限,请您前往设置中启用。";
                okStr = @"我知道了";
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleCancel handler:nil];
                [alertCtl addAction:cancelAction];
                [self presentViewController:alertCtl animated:YES completion:nil];
            }
            else
            {
                UIImagePickerController *vc = [[UIImagePickerController alloc] init];
                vc.delegate = self;
                vc.allowsEditing = NO;
                vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }];
        UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCtl addAction:takePhotoAction];
        [alertCtl addAction:albumAction];
        [alertCtl addAction:canelAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
        
    }
}

#pragma mark -上传图片
- (void)uploadImageReuest:(UIImage *)image {
    [self.view ug_showMBProgressHudOnKeyWindow];
    @weakify(self);
    [[[UGGetBankNoApi alloc] initWithBankImage:image] ug_startWithCompletionBlock:^(UGApiError * _Nonnull apiError, id  _Nonnull object) {
        @strongify(self);
        if (object) {
           //todo获取银行卡信息
            [self checkBankInfo:object[@"cardNo"]];
        } else {
            [self setNable:NO];
            [self.view ug_hiddenMBProgressHudOnKeyWindow];
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark -查询银行信息
-(void)checkBankInfo:(NSString *)cardNo{
    UGGetBankInfoByNoApi *api = [UGGetBankInfoByNoApi new];
    api.cardNo = cardNo;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            self.infoModel = [UGGetBankInfoModel mj_objectWithKeyValues:object];
            [self setNable:YES];
            [self refreshUI:self.infoModel];
        }else{
            [self setNable:NO];
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(void)setNable:(BOOL)isedting{
//    if (!isedting) {
//         self.branchTF.enabled= YES;
//         self.carNoTF.enabled= YES;
//    }else{
//        if (!UG_CheckStrIsEmpty(self.infoModel.province)) {
//            self.branchTF.enabled= NO;
//        }else{
//             self.branchTF.enabled= YES;
//        }
//        
//        if (!UG_CheckStrIsEmpty(self.infoModel.city)) {
//            self.carNoTF.enabled= NO;
//        }else{
//            self.carNoTF.enabled= YES;
//        }
//    }
    //清空旧数据，防止给用户造成误导。
    self.branchTF.text = @"";
    self.carNoTF.text = @"";
    self.rCarNoTF.text = @"";

}

-(void)refreshUI:(UGGetBankInfoModel *)model{
    NSArray *textFieldList = @[self.bankTF, self.branchTF, self.carNoTF, self.rCarNoTF];
    NSArray *valueList = @[model.cardNo,model.province,model.city, model.bank];
    for (int i = 0; i < textFieldList.count; i ++) {
        UITextField *textField = textFieldList[i];
        textField.text = valueList[i];
    }
}

- (void)showTextFieldDefault:(BOOL)showDefalut {
    
    UGMember *member = [UGManager shareInstance].hostInfo.userInfoModel.member;
    NSArray *textFieldList = @[self.nameTF, self.bankTF, self.branchTF, self.carNoTF, self.rCarNoTF];
    NSArray *valueList = @[member.realName ? member.realName : @"", member.cardNo, !UG_CheckStrIsEmpty(member.bankProvince) ? member.bankProvince : @"" ,!UG_CheckStrIsEmpty(member.bankCity) ? member.bankCity : @"" , member.bank];
    
    for (int i = 0; i < textFieldList.count; i ++) {
        UITextField *textField = textFieldList[i];
        textField.text = valueList[i];
    }
    [self chageViewsStauts:showDefalut];
}


- (void)chageViewsStauts:(BOOL)canEdit  {
    self.jyContinerHeight.constant = canEdit ? 0.f : 44.f;
    CGFloat xx = 25.f;
    self.heightConstraint.constant =  canEdit ?  289.f- 44.f-xx : 289.f-xx ;
    self.confirmButton.hidden = canEdit;
    self.arrowBtn.hidden = canEdit;
}


- (IBAction)clickConfirm:(UGButton *)sender {
//    if (self.nameTF.text.length == 0) {
//        [self.view ug_showToastWithToast:@"请输入您的姓名"];
//        return;
//    }
    if (self.bankTF.text.length == 0) {
        [self.view ug_showToastWithToast:@"请输入您的银行卡号"];
        return;
    }
    if (self.branchTF.text.length == 0) {
        [self.view ug_showToastWithToast:@"请输入您的银行卡省份"];
        return;
    }
    if (self.carNoTF.text.length == 0) {
        [self.view ug_showToastWithToast:@"请输入您的银行卡市区"];
        return;
    }
    
    if (self.rCarNoTF.text.length == 0) {
        [self.view ug_showToastWithToast:@"请输入您的银行名称"];
        return;
    }
//
//    if (![self.carNoTF.text isEqualToString:self.rCarNoTF.text]) {
//        [self.view ug_showToastWithToast:@"二次输入卡号不一致"];
//        return;
//    }
    if (UG_CheckStrIsEmpty(self.jypasswordTF.text) || self.jypasswordTF.text.length != 6) {
        [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
        return;
    }
    if ([self isCardVip] && [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding) {
        //1、先判断当前有没有订单  有弹框显示  todo
        UGCheckMemberOtcOrderApi *api = [UGCheckMemberOtcOrderApi alloc];
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (object) {// 返回 true 表示 用户存在交易中的订单，false 表示用户无交易中的订单
                dispatch_async(dispatch_get_main_queue(), ^{
                    @weakify(self);
                    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"修改提示" message:@"您有正在进行中的订单，修改银行卡后，这些订单将使用旧账号完成交易，请您确认是否修改" cancle:@"取消" others:@[@"确认"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                        @strongify(self);
                        if (buttonIndex == 1) {
                            [self sendRequest];
                        }
                    }];
                });
            }else{
                //2、先判断当前有没有订单  没有不显示弹框
                [self sendRequest];
            }
        }];
    }else{
        [self sendRequest];
    }
}

- (void)sendRequest {
    [self.navigationController.view ug_showMBProgressHUD];
    UGBindBankPayApi *api = [UGBindBankPayApi new];
    api.realName = self.nameTF.text;
    api.bank = self.rCarNoTF.text;
    api.cardNo = self.bankTF.text;
    api.bankProvince = self.branchTF.text;
    api.bankCity = self.carNoTF.text;
    api.payPassword = self.jypasswordTF.text;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [self.navigationController.view ug_hiddenMBProgressHUD];
        NSString *des = object ? ! (self.updateBind) ? @"绑定成功"  : @"修改成功！" : apiError.desc;
        [self.view ug_showToastWithToast:des];
        if (object) {
            //刷新信息
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                
            }];
            //绑定成功后，先修改本地数据。
            [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding = YES;
            [UGManager shareInstance].hostInfo.userInfoModel.member.bank = self.rCarNoTF.text;
//            [UGManager shareInstance].hostInfo.userInfoModel.member.branch = self.branchTF.text;
            [UGManager shareInstance].hostInfo.userInfoModel.member.cardNo = self.bankTF.text;
            [UGManager shareInstance].hostInfo.userInfoModel.member.bankProvince = self.branchTF.text;
            [UGManager shareInstance].hostInfo.userInfoModel.member.bankCity = self.carNoTF.text;
            self.hasBinded = YES;
            if (self.handle) {
                self.handle();
            }
            
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                @strongify(self);
                if (self.topVC) {
                    [self.navigationController popToViewController:self.topVC animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }
    }];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.confirmButton.hidden ) {
        return YES;
    }
    
    return NO;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.bankTF)
    {
        if (self.bankTF.text.length)
        {
            [self checkBankInfo:self.bankTF.text];
        }
    }
    
}


- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

-(void)dealloc{
    if (self.hasBinded) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"银行卡绑定成功返回" object:nil];
    }
}

#pragma mark - 从相册识别
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    @weakify(self);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PictureCroppingVC *CropVC = [[PictureCroppingVC alloc]init];
    CropVC.croppingBlock = ^(UIImage *image) {
    @strongify(self);
    UIImage *newImage = [UG_MethodsTool imageCompressWithSimple:image];
    [self uploadImageReuest:newImage];
    };
    CropVC.image = image;
    [self.navigationController pushViewController:CropVC animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
