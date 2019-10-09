//
//  ChangePhoneDetailViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/3/19.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "ChangePhoneDetailViewController.h"
#import "MineNetManager.h"
#import "AccountSettingViewController.h"

@interface ChangePhoneDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel; //提示语
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UITextField *latestPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;//短信验证码
// 国际化需要
@property (weak, nonatomic) IBOutlet UILabel *messageCode;
@property (weak, nonatomic) IBOutlet UILabel *latestPhoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ChangePhoneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"changeBindPhoneNum");
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
     NSString *backStr = [self.phoneNum substringFromIndex:self.phoneNum.length- 4 ];
    self.tipLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"handsetTailNumber"),backStr,LocalizationKey(@"receiveMessageCode")];
    self.messageCode.text = LocalizationKey(@"messageCode");
    self.latestPhoneNumLabel.text = LocalizationKey(@"newPhoneNum");
    self.loginPasswordLabel.text = LocalizationKey(@"loginPassword");
     [_verifyButton setTitle:LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
     [self.submitButton setTitle:LocalizationKey(@"changeBindPhoneNum") forState:UIControlStateNormal];

    self.codeTextField.placeholder = LocalizationKey(@"inputCode");
    self.latestPhoneNum.placeholder = LocalizationKey(@"inputNewPhoneNum");
    self.loginPassword.placeholder = LocalizationKey(@"inputLoginPassword");
    
    // Do any additional setup after loading the view from its nib.
}
//按钮的点击事件
- (IBAction)btnBlick:(UIButton *)sender {
    if (sender.tag == 1) {
        //发送验证码
        
        [EasyShowLodingView showLodingText:LocalizationKey(@"hardLoading")];
        [MineNetManager changePhoneNumCodeForCompleteHandle:^(id resPonseObj, int code) {
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
    }else if (sender.tag == 2){
        //修改绑定手机号
        [self changeBindingPhone];
    }
}
//MARK:--修改绑定手机号
-(void)changeBindingPhone{
   
    if ([self.codeTextField.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMessageCode")];
        return;
    }
    if ([self.latestPhoneNum.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputNewPhoneNum")];
        return;
    }
    if ([self.loginPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputLoginPassword")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager changePhoneNumForPassword:self.loginPassword.text withPhone:self.latestPhoneNum.text withCode:self.codeTextField.text CompleteHandle:^(id resPonseObj, int code) {
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
