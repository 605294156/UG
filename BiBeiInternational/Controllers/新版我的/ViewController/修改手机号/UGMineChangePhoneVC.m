//
//  UGMineChangePhoneVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGMineChangePhoneVC.h"
#import "UGauthOldPhone.h"
#import "UGNewPhoneChangeVC.h"

@interface UGMineChangePhoneVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;
@property (weak, nonatomic) IBOutlet UITextField *codeFiled;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *VerfyLabel;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;
@end

@implementation UGMineChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号码";
    self.phoneFiled.text = [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone;
    self.areaCodeLabel.text =[NSString stringWithFormat:@"+%@",[UGManager shareInstance].hostInfo.userInfoModel.member.areaCode]; 
}

#pragma mark -获取手机短信
- (IBAction)getVerifyCode:(id)sender {
    [self.phoneFiled resignFirstResponder];
    [self.codeFiled resignFirstResponder];
    if (UG_CheckStrIsEmpty(self.phoneFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return;
    }
    [self getCodeRequest];
    [self timeCount];
}

#pragma mark - 获取手机验证码
-(void)getCodeRequest{
    if (UG_CheckStrIsEmpty(self.phoneFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return;
    }
    UGauthOldPhone *api = [[UGauthOldPhone alloc] init];
    api.phone = self.phoneFiled.text;
    api.isVerify = YES;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self.view ug_showToastWithToast:apiError.desc];
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.VerfyLabel.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            [self.view ug_showToastWithToast:@"短信发送成功 ！"];
        }
    }];
}

#pragma mark -下一步
- (IBAction)next:(id)sender {
    if (UG_CheckStrIsEmpty(self.phoneFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return;
    }
    
    if (UG_CheckStrIsEmpty(self.codeFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入验证码"];
        return;
    }
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGauthOldPhone *api = [[UGauthOldPhone alloc] init];
    api.phone = self.phoneFiled.text;
    api.code = self.codeFiled.text;
    api.isVerify = NO;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            UGNewPhoneChangeVC *vc = [[UGNewPhoneChangeVC alloc] init];
            vc.topVC = self.topVC;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
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
                self.VerfyLabel.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.VerfyLabel.hidden = NO;
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.VerfyLabel.text = sStr;
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}
@end
