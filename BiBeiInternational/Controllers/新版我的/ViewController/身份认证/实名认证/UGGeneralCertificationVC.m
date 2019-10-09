//
//  UGGeneralCertificationVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGGeneralCertificationVC.h"
#import "UGButton.h"
#import "UGUnderlineTextField.h"
#import "UGGeneralValidApi.h"
#import "UGGetIdentityNoApi.h"
#import "TXLimitedTextField.h"
#import "UGUpdateRealnameApi.h"
#import "PictureCroppingVC.h"
#import "EditPhotoVC.h"
#import <Photos/Photos.h>
#import "UGCheckMemberOtcOrderApi.h"

@interface UGGeneralCertificationVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *numberTextField;
@property (weak, nonatomic) IBOutlet UGButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *potoBtn;

@end

@implementation UGGeneralCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ! self.isChangeVip ? @"实名认证" : @"修改实名认证";
    self.submitButton.buttonStyle = UGButtonStyleBlue;
    
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        if (self.isCarvip) {
            [self.navigationController popToViewController:self.baseVC animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    if (self.isChangeVip) {
        self.nameTextField.text = [UGManager shareInstance].hostInfo.userInfoModel.member.realName;
        self.numberTextField.text = [UGManager shareInstance].hostInfo.userInfoModel.member.idNumber;
    }
}

- (IBAction)clickSubmit:(UGButton *)sender {
    if (self.nameTextField.text.length == 0) {
        [self.view ug_showToastWithToast:@"请输入您的真实姓名"];
        return;
    }
    
    if (self.numberTextField.text.length == 0) {
        [self.view ug_showToastWithToast:@"请输入您的身份证号码"];
        return;
    }
    if (self.isChangeVip && [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation) {
        //1、先判断当前有没有订单  有弹框显示  todo
        UGCheckMemberOtcOrderApi *api = [UGCheckMemberOtcOrderApi alloc];
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (object) {// 返回 true 表示 用户存在交易中的订单，false 表示用户无交易中的订单
                dispatch_async(dispatch_get_main_queue(), ^{
                    @weakify(self);
                    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"修改提示" message:@"您有正在进行中的订单，修改实名后，这些 订单将使用旧的姓名和账号完成交易，请您确认是否修改" cancle:@"取消" others:@[@"确认"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
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

#pragma mark -识别身份证号
- (IBAction)selectedVerifyCard:(id)sender {
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
    else
    {
         @weakify(self);
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *takePhotoAction =[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EditPhotoVC *takePhotoVC = [[EditPhotoVC alloc]init];
            takePhotoVC.isIDCard = YES;
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


#pragma mark -上传图片
- (void)uploadImageReuest:(UIImage *)image {
    [self.view ug_showMBProgressHudOnKeyWindow];
    @weakify(self);
    [[[UGGetIdentityNoApi alloc] initWithCardImage:image] ug_startWithCompletionBlock:^(UGApiError * _Nonnull apiError, id  _Nonnull object) {
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        @strongify(self);
        if (object && !UG_CheckStrIsEmpty((NSString *)object[@"cardNo"])) {
            self.numberTextField.text = (NSString *)object[@"cardNo"];
        }
        if (object && !UG_CheckStrIsEmpty((NSString *)object[@"name"])) {
            self.nameTextField.text = (NSString *)object[@"name"];
        }
        if (apiError.errorNumber) {
            [self.view ug_showToastWithToast:apiError.desc];
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

- (void)sendRequest {
    if (self.isChangeVip) {
        [MBProgressHUD ug_showHUDToKeyWindow];
        UGUpdateRealnameApi *updateValidApi = [UGUpdateRealnameApi new];
        updateValidApi.realname = self.nameTextField.text;
        updateValidApi.idCard = self.numberTextField.text;
        [updateValidApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            if (!apiError) {
                [self.view ug_showToastWithToast:@"您已完成实名修改！"];
                //更新用户信息数据
                [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                    
                }];
                //先更改本地数据
                [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation = YES;
                
                NSMutableString *str = [[NSMutableString alloc] initWithString:self.numberTextField.text];
                if (str.length > 8) {
                    [str replaceCharactersInRange:NSMakeRange(4, str.length - 4- 4) withString:@"**********"];
                }
                //            //application== nil 设置无效
                //            [UGManager shareInstance].hostInfo.userInfoModel.application.idCard = str;
                //            [UGManager shareInstance].hostInfo.userInfoModel.application.realName = self.nameTextField.text;
                
                if (self.refeshData) {
                    self.refeshData(self.nameTextField.text, str);
                }
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                    @strongify(self);
                        [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }else{
        [MBProgressHUD ug_showHUDToKeyWindow];
        UGGeneralValidApi *validApi = [UGGeneralValidApi new];
        validApi.realname = self.nameTextField.text;
        validApi.idCard = self.numberTextField.text;
        [validApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            if (!apiError) {
                [self.view ug_showToastWithToast:@"您已完成实名认证！"];
                //更新用户信息数据
                [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                    
                }];
                
                //先更改本地数据
                [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation = YES;
                
                NSMutableString *str = [[NSMutableString alloc] initWithString:self.numberTextField.text];
                if (str.length > 8) {
                    [str replaceCharactersInRange:NSMakeRange(4, str.length - 4- 4) withString:@"**********"];
                }
                //            //application== nil 设置无效
                //            [UGManager shareInstance].hostInfo.userInfoModel.application.idCard = str;
                //            [UGManager shareInstance].hostInfo.userInfoModel.application.realName = self.nameTextField.text;
                
                if (self.refeshData) {
                    self.refeshData(self.nameTextField.text, str);
                }
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                    @strongify(self);
                    if (self.isCarvip) {
                        [self.navigationController popToViewController:self.baseVC animated:YES];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            } else {
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }
}


@end
