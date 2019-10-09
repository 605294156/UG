//
//  UGReviseWalletWithGoogleAndFaceVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/15.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGReviseWalletWithGoogleAndFaceVC.h"
#import "UGReviseWalletPasswordVC.h"
#import "UGAuthenticationViewController.h"
#import "UGMGFaceTool.h"
#import "UGMakeTrueMnemonnicVC.h"

@interface UGReviseWalletWithGoogleAndFaceVC ()
@property (weak, nonatomic) IBOutlet UIButton *phoneResetButton;
@property (weak, nonatomic) IBOutlet UIButton *auxiliariesResetButton;
@end

@implementation UGReviseWalletWithGoogleAndFaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UG钱包支付密码重置";
    self.phoneResetButton.hidden = ![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
    self.auxiliariesResetButton.hidden = [UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
}

#pragma mark -手机验证码重置
- (IBAction)googleVerify:(id)sender {
//    if ([self hasBindingGoogleValidator]) {//2.0换手机号
        UGReviseWalletPasswordVC *vc = [UGReviseWalletPasswordVC new];
        vc.topVC = self.topVC;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}
#pragma mark - 助记词重置支付密码
- (IBAction)auxiliariesResetAction:(id)sender {
    UGMakeTrueMnemonnicVC *vc = [[UGMakeTrueMnemonnicVC alloc] init];
    vc.isfromRegister = NO;
    vc.isPayPassword = YES;
    vc.topVC = self.topVC;
    vc.username = [UGManager shareInstance].hostInfo.userInfoModel.member.registername;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -人脸识别重置
- (IBAction)faceVerify:(id)sender {
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
    [self faceSend];
}

-(void)faceSend{
    @weakify(self);
    [UGMGFaceTool ug_mgFaceVerifyWith:self WithTypeStr:@"UPDATE_JYPASSWORD" WithUserName:[UGManager shareInstance].hostInfo.username callback:^(NSUInteger Code, NSString * _Nonnull Message, NSString * _Nonnull key) {
        @strongify(self);
        if (Code == 51000) {
            [UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus = @"1";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转到修改支付密码页面
                UGReviseWalletPasswordVC *vc = [UGReviseWalletPasswordVC new];
                vc.isFace = YES;
                vc.token = key;
                vc.topVC = self.topVC;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showFaceAlterView:Message];
            });
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
