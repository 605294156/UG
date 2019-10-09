//
//  MoneyPasswordViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "ForgetMoneyPassViewController.h"
#import "MineNetManager.h"
#import "AccountSettingViewController.h"
@interface ForgetMoneyPassViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//提示语设置
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;//新密码
@property (weak, nonatomic) IBOutlet UITextField *certainPassword;//确认密码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UITextField *code;//验证码
@property (weak, nonatomic) IBOutlet UIButton *codeButton;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIView *codeView;//验证码视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewHeight;//验证码视图的高度
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestMoneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *certainMoneyPasswordLabel;

@end

@implementation ForgetMoneyPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"changeMoneyPassword");
    self.moneyPassword.secureTextEntry = YES;
    self.certainPassword.secureTextEntry = YES;
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.tipLabel.text = LocalizationKey(@"changeMoneyPasswordTip");
    self.codeLabel.text = LocalizationKey(@"verifyCode");
    self.latestMoneyPasswordLabel.text = LocalizationKey(@"newMoneyPassword");
    self.certainMoneyPasswordLabel.text = LocalizationKey(@"certainMoneyPassword");
    self.code.placeholder = LocalizationKey(@"inputCode");
    self.moneyPassword.placeholder = LocalizationKey(@"inputNewMoneyPassword");
    self.certainPassword.placeholder = LocalizationKey(@"inputCertainMoneyPassword");
    [self.codeButton setTitle:LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
     [self.setButton setTitle:LocalizationKey(@"certainChange") forState:UIControlStateNormal];
}
//MARK:--获取验证码的点击事件
- (IBAction)codeBtnClick:(UIButton *)sender {
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardLoading")];
    [MineNetManager resetMoneyPasswordCodeForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view ug_showToastWithToast:LocalizationKey(@"getMessageCodeTip")];
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.codeButton setTitle:LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
                            self.codeButton.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 90;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.codeButton setTitle: [NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                            self.codeButton.userInteractionEnabled = NO;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }
    }];
}
//MARK:--提交按钮的点击事件
- (IBAction)submitBtnClick:(UIButton *)sender {
    
    [self changeMoneyPassword];
}
//MARK:--修改资金密码的接口
-(void)changeMoneyPassword{
    
    if ([self.code.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputCode")];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputNewMoneyPassword")];
        return;
    }
    if ([self.certainPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputCertainMoneyPassword")];
        return;
    }
    if (![self.certainPassword.text isEqualToString:self.moneyPassword.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"checkPassword")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    [MineNetManager resetMoneyPasswordForCode:self.code.text withNewPassword:self.moneyPassword.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[AccountSettingViewController class]]) {
                            AccountSettingViewController *accountVC =(AccountSettingViewController *)controller;
                            [self.navigationController popToViewController:accountVC animated:YES];
                        }
                    }
                });

            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
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
