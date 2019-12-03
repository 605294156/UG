//
//  UGWechaPayViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGWechaPayViewController.h"
#import "UGButton.h"
#import "UGBindWechatPayApi.h"
#import "UGUploadImageRequest.h"
#import "UGShowBindPayInfoViewController.h"
#import "UGUnbindPayModelApi.h"
#import "UGCheckMemberOtcOrderApi.h"

@interface UGWechaPayViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UGButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UITextField *wechatTextField;
@property (weak, nonatomic) IBOutlet UITextField *jyPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;//所有控件的容器View

@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UITextField *userNameTestFile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhong_top;
@property (weak, nonatomic) IBOutlet UIView *accoutTopLine;

@property (nonatomic, strong) UGShowBindPayInfoViewController *bindInfoViewController;//展示已绑定信息，不可修改
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonDownLayout;

@end

@implementation UGWechaPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.payType == UGPayTypeUnionPay ? @"云闪付" : (self.payType == UGPayTypeWeChatPay ? @"微信支付" : @"支付宝");
    self.accountLabel.text = self.payType == UGPayTypeUnionPay ? @"云闪付账号" : (self.payType == UGPayTypeWeChatPay ? @"微信账号" : @"支付宝账号");
    self.wechatTextField.placeholder = self.payType ==  UGPayTypeUnionPay ? @"请输入云闪付账号" : (self.payType == UGPayTypeWeChatPay ? @"请输入您的微信账号" : @"请输入您的支付宝账号");
    self.wechatTextField.delegate = self;
    self.confirmButton.buttonStyle = UGButtonStyleNone;
    
    if (self.updateBind) {
        @weakify(self);
        [self setupBarButtonItemWithTitle:@"编辑" type:UGBarImteTypeRight titleColor:UG_UIColorFromHex(333333) callBack:^(UIBarButtonItem * _Nonnull item) {
            @strongify(self);
            UIButton *rightButton = item.customView;
            rightButton.selected = !rightButton.selected;
            [self changeShowContainerView:!rightButton.selected];
        }];
        
        [self showTextFieldDefault];
        [self changeShowContainerView:YES];
    }
    if (self.payType == UGPayTypeUnionPay) {
        self.userNameTestFile.hidden = NO;
        self.userLab.hidden = NO;
        self.userNameH.constant = 60.0f;
        self.centerH.constant = 198.0f;
        self.userNameTestFile.text = [UGManager shareInstance].hostInfo.userInfoModel.member.realName;
    }else{
        self.userNameTestFile.hidden = YES;
        self.userLab.superview.hidden = YES;
        self.userNameH.constant = 0.0f;
        self.accoutTopLine.hidden = NO;
        self.centerH.constant = 138;
        self.zhong_top.constant = 0;
    }
    //设配4寸屏幕
    if ([UG_MethodsTool is4InchesScreen]) {
        self.confirmButtonDownLayout.constant = 40;
    }
}

- (void)showTextFieldDefault {

    UGMember *member = [UGManager shareInstance].hostInfo.userInfoModel.member;
        
    self.wechatTextField.text = self.payType == UGPayTypeUnionPay ? member.unionPay : ( self.payType == UGPayTypeWeChatPay ? member.wechat : member.aliNo);
    
    NSString *qrCodeUrl = self.payType == UGPayTypeUnionPay ? member.qrUnionCodeUrl : (self.payType == UGPayTypeWeChatPay ? member.qrWeCodeUrl : member.qrCodeUrl);
    
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrCodeUrl] placeholderImage:[UIImage imageNamed:@"qr_defult"] ];

}

- (void)changeShowContainerView:(BOOL)showBindInfo  {
    [self.view endEditing:YES];
    UIView *fromView = showBindInfo ? self.containerView : self.bindInfoViewController.view;
    UIView *toView = showBindInfo ? self.bindInfoViewController.view : self.containerView;
    [UIView transitionFromView:fromView toView:toView duration:0.2f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionShowHideTransitionViews completion:nil];
    if (self.payType == UGPayTypeUnionPay) {
        self.userNameTestFile.hidden = NO;
        self.userLab.hidden = NO;
        self.userNameH.constant = 60.0f;
        self.centerH.constant = 198.0f;
        self.userNameTestFile.text = [UGManager shareInstance].hostInfo.userInfoModel.member.realName;
    }else{
        self.userNameTestFile.hidden = YES;
        self.userLab.hidden = YES;
        self.userNameH.constant = 0.0f;
        self.centerH.constant = 138;
    }
}


- (IBAction)tapAddPhoto:(UITapGestureRecognizer *)sender {
    @weakify(self);
    [self showTakePhotoChooseWithMaxCount:1 WithPoto:YES handle:^(NSArray<UIImage *> * _Nonnull imageList) {
        @strongify(self);
        if (imageList.count > 0) {
            self.qrCodeImageView.image = imageList.firstObject;
        }
    }];
}

- (IBAction)clickConfirm:(UGButton *)sender {
    
    if ([self.qrCodeImageView.image isEqual:[UIImage imageNamed:@"mine_add"]]) {
        [self.view ug_showToastWithToast:@"请上传收款码"];
        return;
    }
    
    if(self.payType == UGPayTypeAliPay ){
        if (self.wechatTextField.text.length <6 || self.wechatTextField.text.length >32) {
            [self.view ug_showToastWithToast:@"请输入6-32位支付宝账号"];
            return;
        }
    }else if(self.payType == UGPayTypeWeChatPay){
        if (self.wechatTextField.text.length <6 || self.wechatTextField.text.length >20) {
            [self.view ug_showToastWithToast:@"请输入6-20位微信账号"];
            return;
        }
    }else if(self.payType == UGPayTypeUnionPay){
        if (self.wechatTextField.text.length <6 || self.wechatTextField.text.length >20) {
            [self.view ug_showToastWithToast:@"请输入6-32位云闪付账号"];
            return;
        }
    }

    if (UG_CheckStrIsEmpty(self.jyPasswordTextField.text) || self.jyPasswordTextField.text.length != 6) {
        [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
        return;
    }
    
    if ([self isCardVip] && self.payType == UGPayTypeUnionPay && [UGManager shareInstance].hostInfo.userInfoModel.hasUnionPay) {
        //1、先判断当前有没有订单  有弹框显示  todo
        UGCheckMemberOtcOrderApi *api = [UGCheckMemberOtcOrderApi alloc];
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (object) {// 返回 true 表示 用户存在交易中的订单，false 表示用户无交易中的订单
                dispatch_async(dispatch_get_main_queue(), ^{
                    @weakify(self);
                    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"修改提示" message:@"您有正在进行中的订单，修改云闪付后，这些订单将使用旧账号完成交易，请您确认是否修改" cancle:@"取消" others:@[@"确认"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                        @strongify(self);
                        if (buttonIndex == 1) {
                                [self uploadImageReuest];
                        }
                    }];
                });
            }else{
                //2、先判断当前有没有订单  没有不显示弹框
                  [self uploadImageReuest];
            }
        }];
    }else{
            [self uploadImageReuest];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

//上传图片
- (void)uploadImageReuest {
    [self.navigationController.view ug_showMBProgressHUD];
    [[[UGUploadImageRequest alloc] initWithImage:self.qrCodeImageView.image] ug_startWithCompletionBlock:^(UGApiError * _Nonnull apiError, id  _Nonnull object) {
        if (object && [object isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic addEntriesFromDictionary:object];
            NSArray *arr = [NSArray arrayWithArray:[dic allValues]];
            if (arr.count>0) {
                 [self sendRequestWithQrCodeUrl:arr[0]];
            }
        }else {
            [self.navigationController.view ug_hiddenMBProgressHUD];
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

//发送请求
- (void)sendRequestWithQrCodeUrl:(NSString *)qrCodeUrl  {
    UGBindWechatPayApi *bindPayApi = [UGBindWechatPayApi new];
    bindPayApi.payTpe = self.payType;
    bindPayApi.account = self.wechatTextField.text;
    bindPayApi.realName = @"";
    bindPayApi.payPassword = self.jyPasswordTextField.text;
    bindPayApi.qrUrl = qrCodeUrl == nil ? @"" : qrCodeUrl;
    @weakify(self);
    [bindPayApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.navigationController.view ug_hiddenMBProgressHUD];
        NSString *des = object ? ! (self.updateBind) ? @"绑定成功"  : @"修改成功！" : apiError.desc;
        [self.view ug_showToastWithToast:des];
        if (object) {
            //刷新数据
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                
            }];
            //绑定成功后，先修改本地数据。
            if (self.payType == UGPayTypeAliPay) {
                [UGManager shareInstance].hostInfo.userInfoModel.hasAliPay = YES;
                [UGManager shareInstance].hostInfo.userInfoModel.member.aliNo = self.wechatTextField.text;

            } else if (self.payType == UGPayTypeWeChatPay) {
                [UGManager shareInstance].hostInfo.userInfoModel.hasWechatPay = YES;
                [UGManager shareInstance].hostInfo.userInfoModel.member.wechat = self.wechatTextField.text;
            }else if (self.payType == UGPayTypeUnionPay) {
                [UGManager shareInstance].hostInfo.userInfoModel.hasUnionPay = YES;
                [UGManager shareInstance].hostInfo.userInfoModel.member.unionPay = self.wechatTextField.text;
            }
            
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

#pragma mark - Getter Method

- (UGShowBindPayInfoViewController *)bindInfoViewController {
    if (!_bindInfoViewController) {
        _bindInfoViewController = [UGShowBindPayInfoViewController new];
        _bindInfoViewController.payType = self.payType;
        _bindInfoViewController.view.frame = self.view.bounds;
        @weakify(self);
        _bindInfoViewController.clickUnBinding = ^(UGPayType payType) {
            @strongify(self);
            NSString *meaStr = (payType == UGPayTypeWeChatPay) ? @"您确认要解绑当前微信支付 ?" :  (payType == UGPayTypeUnionPay ? @"您确认要解绑当前云闪付 ?" : @"您确认要解绑当前支付宝 ?")  ;
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"解除绑定" message:meaStr cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                if (buttonIndex ==1 ){
                    [self unBnding:payType];
                }
            }];
        };
        [self addChildViewController:_bindInfoViewController];
        [self.view addSubview:_bindInfoViewController.view];
    }
    return _bindInfoViewController;
}

-(void)unBnding:(UGPayType)payType{
    [self.navigationController.view ug_showMBProgressHUD];
    UGUnbindPayModelApi *api = [UGUnbindPayModelApi new];
    if (payType == UGPayTypeWeChatPay) {
        api.unbindWechat = @"1";
    }
    else if (payType == UGPayTypeAliPay) {
        api.unbindAliPay = @"1";
    }
    else if (payType == UGPayTypeUnionPay) {
        api.unbindUnionPay= @"1";
    }
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.navigationController.view ug_hiddenMBProgressHUD];
        if (object) {
            [self.view ug_showToastWithToast:object];
            //刷新数据
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                
            }];
            //绑定成功后，先修改本地数据。
            if (self.payType == UGPayTypeAliPay) {
                [UGManager shareInstance].hostInfo.userInfoModel.hasAliPay = NO;
                [UGManager shareInstance].hostInfo.userInfoModel.member.aliNo = @"";
                
            } else if (self.payType == UGPayTypeWeChatPay) {
                [UGManager shareInstance].hostInfo.userInfoModel.hasWechatPay = NO;
                [UGManager shareInstance].hostInfo.userInfoModel.member.wechat = @"";
            }else if (self.payType == UGPayTypeUnionPay) {
                [UGManager shareInstance].hostInfo.userInfoModel.hasUnionPay = NO;
                [UGManager shareInstance].hostInfo.userInfoModel.member.unionPay = @"";
            }
            
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
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

@end
