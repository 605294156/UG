//
//  UGReSettingPasswordVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReSettingPasswordVC.h"
#import "UGRevisePasswordVC.h"
#import "UGGeneralCertificationVC.h"
#import "UGAuthenticationViewController.h"
#import "UGAbleToValidApi.h"
#import "UGMGFaceTool.h"
#import "UGMakeTrueMnemonnicVC.h"
#import "UGFindPassWordVC.h"
@interface UGReSettingPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *phoneResetButton;
@property (weak, nonatomic) IBOutlet UIButton *auxiliariesResetButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auxiliariesButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auxiliariesButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneButtonTop;
@property (weak, nonatomic) IBOutlet UILabel *usernameTittleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faceBtnTop;



@end

@implementation UGReSettingPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录密码重置";
    if (!self.isLogin) {
        
        if ([UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone) {
            self.usernameTittleLabel.text = @"手机号";
            if (!UG_CheckStrIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone))
            {
                self.userNameTextField.text = [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone;
                self.userNameTextField.enabled = NO;
            }else{
                self.userNameTextField.enabled = YES;
            }
            
            self.faceBtnTop.constant = -22.f;
        }
        else
        {
            self.usernameTittleLabel.text = @"用户名";
            if (!UG_CheckStrIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.member.registername))
            {
                self.userNameTextField.text = [UGManager shareInstance].hostInfo.userInfoModel.member.registername;
                self.userNameTextField.enabled = NO;
            }else{
                self.userNameTextField.enabled = YES;
            }
        }
        self.phoneResetButton.hidden = ![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
        self.auxiliariesResetButton.hidden = [UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
        self.auxiliariesButtonTop.constant = [UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone ?  0.0f : 35.0f;
        self.auxiliariesButtonHeight.constant = [UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone ? 0.0f : 46.0f ;
        self.phoneButtonTop.constant = [UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone ? 90.0f : 9.0f ;
    }
}

- (IBAction)google:(id)sender {
    //找回密码时，只需要手机号
    if (self.isLogin) {
      UGFindPassWordVC *vc = [UGFindPassWordVC new];
      vc.topVC = self.topVC;
      [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (UG_CheckStrIsEmpty(self.userNameTextField.text)) {
            [self.view ug_showToastWithToast:@"请输入要重置的用户名"];
            return;
        }
        
        if (self.isLogin) {  //2.0换手机号
            //        [self getAbleToValidComplate:^(id obj) {
            //            UGAbleValidModel *model = [UGAbleValidModel mj_objectWithKeyValues:obj];
            //            if ([model.hasGoogleValidation isEqualToString:@"1"]) {
            [self goToNext:NO];
            //            }else{
            //                [self.view ug_showToastWithToast:@"该用户未绑定谷歌验证器，无法进行密码重置！"];
            //            }
            //        }];
        }else{
            //        if ([self hasBindingGoogleValidator]) {//2.0换手机号
            [self goToNext:NO];
            //        }
        }
    }

}

- (IBAction)face:(id)sender {
    if (UG_CheckStrIsEmpty(self.userNameTextField.text)) {
        [self.view ug_showToastWithToast:@"请输入要重置的用户名"];
        return;
    }
    if (self.isLogin) {
         @weakify(self);
        [self getAbleToValidComplate:^(id obj) {
             @strongify(self);
            UGAbleValidModel *model = [UGAbleValidModel mj_objectWithKeyValues:obj];
            if ([model.faceStatus isEqualToString:@"1"]) {
                 [self goToNext:YES];
            }else{
                [self.view ug_showToastWithToast:@"该用户未进行人脸识别认证，无法进行密码重置！"];
            }
        }];
    }else{
        if (![self hasRealnameValidation] || ![self hasHighValidation] ||  ![self hasFaceValidation]) {
            @weakify(self);
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，操作前，请您先完成所有身份认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                @strongify(self);
                if (buttonIndex == 1) {
                    [self.navigationController pushViewController:[UGAuthenticationViewController new] animated:YES];
                }
            }];
            return;
        }
        [self goToNext:YES];
    }
}
#pragma mark - 助记词重置登录密码
- (IBAction)auxiliariesResetAction:(id)sender {
    if (!UG_CheckStrIsEmpty(self.userNameTextField.text)) {
        
        if ( [UGManager shareInstance].hasLogged) {
            UGMakeTrueMnemonnicVC *vc = [[UGMakeTrueMnemonnicVC alloc]init];
            vc.username = self.userNameTextField.text;
            vc.topVC = self.topVC;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            @weakify(self);
            [self getAbleToValidComplate:^(id obj) {
            @strongify(self);
            UGAbleValidModel *model = [UGAbleValidModel mj_objectWithKeyValues:obj];
            if ([model.bindAuxiliaries isEqualToString:@"1"]) {
                 [self auxiliariesGoToNext];
                }else{
                    [self.view ug_showToastWithToast:@"该用户未设置助记词，无法进行密码重置！"];
                }
            }];
        }
        
    }
    else
    {
        [self.view ug_showToastWithToast:@"请输入要重置的用户名"];
    }
}

#pragma mark - 助记词找回密码
-(void)auxiliariesGoToNext
{
    UGMakeTrueMnemonnicVC *vc = [[UGMakeTrueMnemonnicVC alloc]init];
    vc.isFindLoginPassword = YES;
    vc.username = self.userNameTextField.text;
    vc.topVC = self.topVC;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)goToNext:(BOOL)isFace{
    [self.view endEditing:YES];
    if(isFace){
        [self faceVerify];
    }else{
        UGRevisePasswordVC *vc = [UGRevisePasswordVC new];
        vc.fromeLogin = self.isLogin;
        vc.username = self.userNameTextField.text;
        vc.topVC = self.topVC;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)faceVerify{
    @weakify(self);
    NSString *vaildString = @"";
    if ([UGManager shareInstance].hasLogged) {
        vaildString =[UGManager shareInstance].hostInfo.username;
    }
    else
    {
        vaildString = self.userNameTextField.text;
    }
    [UGMGFaceTool ug_mgFaceVerifyWith:self WithTypeStr:@"UPDATE_PASSWORD" WithUserName:vaildString callback:^(NSUInteger Code, NSString * _Nonnull Message, NSString * _Nonnull key) {
        @strongify(self);
        if (Code == 51000) {
            [UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus = @"1";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转到密码设置页面
                UGRevisePasswordVC *vc = [UGRevisePasswordVC new];
                vc.fromeFace = YES;
                vc.fromeLogin = self.isLogin;
                vc.username = self.userNameTextField.text;
                vc.topVC = self.topVC;
                vc.faceCode = [key isKindOfClass:[NSString class]] ? (NSString *)key : @"";
                [self.navigationController pushViewController: vc animated:YES];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showFaceAlterView:Message];
            });
        }
    }];
}

// 助记词相关
-(void)getAbleToValidComplate:(void(^)(id obj))completeHandle
{
    UGAbleToValidApi *api = [UGAbleToValidApi new];
    api.username = self.userNameTextField.text;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (apiError.errorNumber) {
            [self.view ug_showToastWithToast:apiError.desc];
            return ;
        }else
        {
            completeHandle(object);
        }
        
    }];
}

//是否实名认证
- (BOOL)hasRealnameValidation {
    return [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation;
}

//是否高级认证
- (BOOL)hasHighValidation {
    return [UGManager shareInstance].hostInfo.userInfoModel.hasHighValidation;
    
}

//是否人脸识别认证
-(BOOL)hasFaceValidation {
    return [[UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus isEqualToString:@"1"];
}
@end
