//
//  UGReviseWalletPasswordVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReviseWalletPasswordVC.h"
#import "UGButton.h"
#import "TXLimitedTextField.h"
//#import "UGReviseJYpasswordApi.h"
#import "UGNewUpdateMarketPasswordApi.h"
#import "UGResetUserPassword.h"

@interface UGReviseWalletPasswordVC ()
@property (weak, nonatomic) IBOutlet UGButton *confirmButton;

@property (weak, nonatomic) IBOutlet TXLimitedTextField *nPasswordField;//新密码
@property (weak, nonatomic) IBOutlet TXLimitedTextField *rPasswordField;//重复新密码
@property (weak, nonatomic) IBOutlet TXLimitedTextField *codeField;//谷歌验证码
@property (weak, nonatomic) IBOutlet UIView *googleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet TXLimitedTextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyLab;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation UGReviseWalletPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"UG钱包支付密码重置";
    self.confirmButton.buttonStyle = UGButtonStyleBlue;
    self.phoneField.text = [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone;
    self.phoneLabel.text = [NSString stringWithFormat:@"+%@",[UGManager shareInstance].hostInfo.userInfoModel.member.areaCode];
    if (self.isFace || self.isAuxiliaries) {
        self.googleView.hidden = YES;
        self.contentHeight.constant -= 52+60;
        self.phoneView.hidden = YES;
    }
}

#pragma mark -获取验证码
- (IBAction)getVerifyCode:(id)sender {
    if (self.phoneField.text.length == 0 && ! self.isFace) {
        [self.view ug_showToastWithToast:@"手机号不能为空"];
        return;
    }
    [self timeCount];
    UGNewUpdateMarketPasswordApi *reviseJYPasswordApi = [UGNewUpdateMarketPasswordApi new];
    reviseJYPasswordApi.isVerify = YES;
    reviseJYPasswordApi.phone = self.phoneField.text;
    [reviseJYPasswordApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self.view ug_showToastWithToast:apiError.desc];
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.verifyLab.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            [self.view ug_showToastWithToast:@"短信发送成功 ！"];
        }
    }];
}

#pragma mark -倒计时
-(void)timeCount{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.verifyLab.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verifyLab.hidden = NO;
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.verifyLab.text = sStr;
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

//确定修改
- (IBAction)clickConfirm:(UGButton *)sender {

    if (self.nPasswordField.text.length != 6  ) {
        [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
        return;
    }
    
    if (![self.nPasswordField.text isEqualToString:self.rPasswordField.text]) {
        [self.view ug_showToastWithToast:@"请您确认两次输入密码一致！"];
        return;
    }
    
    if (self.phoneField.text.length == 0 && ! self.isFace && ! self.isAuxiliaries) {
        [self.view ug_showToastWithToast:@"手机号不能为空"];
        return;
    }

    if (self.codeField.text.length == 0 && !self.isFace && ! self.isAuxiliaries) {
        [self.view ug_showToastWithToast:@"验证码不能为空"];
        return;
    }
    if (self.isAuxiliaries) {
        [self resetUserPassword];
    }else{
       [self reviseJYPassword];
    }
    
}

#pragma mark -助记词修改支付密码
-(void)resetUserPassword{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UGResetUserPassword *reviseJYPasswordApi = [UGResetUserPassword new];
    reviseJYPasswordApi.password = self.nPasswordField.text;
    reviseJYPasswordApi.type = @"2";
    reviseJYPasswordApi.auxiliaries = self.auxiliaries;
    [reviseJYPasswordApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            [self.view ug_showToastWithToast:@"修改支付密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.topVC) {
                    [self.navigationController popToViewController:self.topVC animated:YES];
                }
            });
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

//修改交易密码
- (void)reviseJYPassword {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UGNewUpdateMarketPasswordApi *reviseJYPasswordApi = [UGNewUpdateMarketPasswordApi new];
    reviseJYPasswordApi.nPassword = self.nPasswordField.text;
    reviseJYPasswordApi.isVerify = NO;
    if (!self.isFace) {
          reviseJYPasswordApi.code = self.codeField.text;
         reviseJYPasswordApi.phone = self.phoneField.text;
    }else{
          reviseJYPasswordApi.bizToken = self.token;
    }
  
    [reviseJYPasswordApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            [self.view ug_showToastWithToast:@"修改支付密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.topVC) {
                    [self.navigationController popToViewController:self.topVC animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}
@end
