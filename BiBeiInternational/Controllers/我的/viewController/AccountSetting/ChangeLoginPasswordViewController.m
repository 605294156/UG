//
//  ChangeLoginPasswordViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "ChangeLoginPasswordViewController.h"
#import "MineNetManager.h"

@interface ChangeLoginPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;//旧登录密码
@property (weak, nonatomic) IBOutlet UITextField *latestPassword;//新登录密码
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//提示文本
@property (weak, nonatomic) IBOutlet UITextField *certainPassword;//确认密码
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *oldLoginPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestLoginPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *certainPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *verifyCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *changButton;//更改登录密码按钮
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;//界面顶部的提示语

@end

@implementation ChangeLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"changeLoginPassword");
    //提示语
    NSString *beforeStr = [self.phoneNum substringToIndex:3];
    NSString *backStr = [self.phoneNum substringFromIndex:self.phoneNum.length- 4 ];
    self.tipLabel.text = [NSString stringWithFormat:@"%@%@****%@",LocalizationKey(@"changeLoginPasswordTip1"),beforeStr,backStr];
    self.oldLoginPasswordLabel.text = LocalizationKey(@"oldLoginPassword");
     self.latestLoginPasswordLabel.text = LocalizationKey(@"newLoginPassword");
     self.certainPasswordLabel.text = LocalizationKey(@"certainPassword");
     self.verifyCodeLabel.text = LocalizationKey(@"verifyCode");
    [self.changButton setTitle: LocalizationKey(@"changeLoginPassword") forState:UIControlStateNormal];
    [self.verifyButton setTitle: LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
    self.tipLabel1.text = LocalizationKey(@"changeLoginPasswordTip");
    self.verificationCode.placeholder = LocalizationKey(@"inputCode");
    self.oldPassword.placeholder = LocalizationKey(@"inputOldLoginPassword");
    self.latestPassword.placeholder = LocalizationKey(@"inputNewLoginPassword");
    self.certainPassword.placeholder = LocalizationKey(@"inputCertainLoginPassword");
    //[self rightBarItemWithTitle:@"忘记密码"];
   
}
//MARK:--导航栏右边按钮点击事件
-(void)RighttouchEvent{
    NSLog(@"帮助点击事件");
//    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
//    [self.navigationController pushViewController:forgetVC animated:YES];
}
//MARK:--获取验证码的点击事件
- (IBAction)getVerificationCodeBtnClick:(UIButton *)sender {
    [EasyShowLodingView showLodingText: LocalizationKey(@"hardLoading")];
    [MineNetManager resetLoginPasswordCodeForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view ug_showToastWithToast: LocalizationKey(@"getMessageCodeTip")];
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.verifyButton setTitle: LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
                            self.verifyButton.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 90;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.verifyButton setTitle: [NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                            self.verifyButton.userInteractionEnabled = NO;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
                
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }
    }];
}
//MARK:--更改登录密码按钮点击事件
- (IBAction)submitBtnClick:(UIButton *)sender {
    
    if ([self.oldPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast: LocalizationKey(@"nputOldLoginPassword")];
        return;
    }
    if ([self.latestPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast: LocalizationKey(@"inputNewLoginPassword")];
        return;
    }
    if ([self.certainPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputCertainLoginPassword")];
        return;
    }
    if (![self.latestPassword.text isEqualToString:self.certainPassword.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"checkPassword")];
        return;
    }
    if ([self.verificationCode.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputCode")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager resetLoginPasswordForCode:self.verificationCode.text withOldPassword:self.oldPassword.text withLatestPassword:self.latestPassword.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast: LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
