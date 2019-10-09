//
//  BindingPhoneViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "MineNetManager.h"

@interface BindingPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *phoneCode;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *MSMLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"bindPhoneNumber");
    self.phoneLabel.text = LocalizationKey(@"phoneNum");
    self.MSMLabel.text = LocalizationKey(@"messageCode");
    self.loginPasswordLabel.text = LocalizationKey(@"loginPassword");
    [self.bindButton setTitle:LocalizationKey(@"bindPhoneNumber") forState:UIControlStateNormal];
    [self.verifyButton setTitle:LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
    self.phoneNum.placeholder = LocalizationKey(@"inputMobile");
    self.phoneCode.placeholder = LocalizationKey(@"inputPhoneCode");
    self.loginPassword.placeholder = LocalizationKey(@"inputLoginPassword");
}
//MARK:---获取验证码的点击事件
- (IBAction)getEmailCodeBtnClick:(UIButton *)sender {
    if ([self.phoneNum.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMobile")];
        return;
    }
    if (![ToolUtil checkPhoneNumInput:self.phoneNum.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"judgePhoneNum")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager bindingPhoneCodeForPhone:self.phoneNum.text CompleteHandle:^(id resPonseObj, int code) {
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
                            [self.verifyButton setTitle:LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
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
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }
    }];
}
//MARK:--绑定手机的点击事件
- (IBAction)bindingEmailBtnClick:(UIButton *)sender {
    if ([self.phoneNum.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMobile")];
        return;
    }
    if (![ToolUtil checkPhoneNumInput:self.phoneNum.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"judgePhoneNum")];
        return;
    }
    if ([self.phoneCode.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputPhoneCode")];
        return;
    }
    if ([self.loginPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputLoginPassword")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager bindingPhoneForCode:self.phoneCode.text withPassword:self.loginPassword.text withPhone:self.phoneNum.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
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
