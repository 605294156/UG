//
//  BindingEmailViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BindingEmailViewController.h"
#import "MineNetManager.h"

@interface BindingEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAccount;
@property (weak, nonatomic) IBOutlet UITextField *emailCode;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certainBindingViewHeight;//绑定邮箱
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBindingViewHeight; //解绑邮箱
@property (weak, nonatomic) IBOutlet UIView *certainBindingView;
@property (weak, nonatomic) IBOutlet UIView *cancelBindingView;
@property (weak, nonatomic) IBOutlet UILabel *emailNum;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *emailAccountLabel;//邮箱账号
@property (weak, nonatomic) IBOutlet UILabel *emailCodeLabel;//邮箱验证码
@property (weak, nonatomic) IBOutlet UILabel *loginPasswordLabel; //登录密码
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮箱


@end

@implementation BindingEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    if (self.bindingStatus == 1) {
        //绑定状态，需要解绑
        self.title = LocalizationKey(@"unBundlingEmail");
        self.certainBindingViewHeight.constant = 0;
        self.certainBindingView.hidden = YES;
        self.emailNum.text = self.emailStr;
        self.bindingButton.hidden = YES;
        [self.bindingButton setTitle:LocalizationKey(@"unBundlingEmail") forState:UIControlStateNormal];
        self.bindingButton.userInteractionEnabled = NO;
    }else{
        self.title = LocalizationKey(@"bindingEmail");
        self.cancelBindingViewHeight.constant = 0;
        self.cancelBindingView.hidden = YES;
        [self.bindingButton setTitle:LocalizationKey(@"bindingEmail") forState:UIControlStateNormal];
        self.bindingButton.hidden = NO;
       
    }
    self.emailAccountLabel.text = LocalizationKey(@"emailAccount");
    self.emailCodeLabel.text = LocalizationKey(@"emailCode");
    self.loginPasswordLabel.text = LocalizationKey(@"loginPassword");
    self.emailLabel.text = LocalizationKey(@"email");
    [self.verifyButton setTitle:LocalizationKey(@"getVerifyCode") forState:UIControlStateNormal];
    
     self.emailAccount.placeholder = LocalizationKey(@"inputEmailAccount");
     self.emailCode.placeholder = LocalizationKey(@"inputEmailValidate");
    self.loginPassword.placeholder = LocalizationKey(@"inputLoginPassword");
}

//MARK:---获取验证码的点击事件
- (IBAction)getEmailCodeBtnClick:(UIButton *)sender {
    
    if ([self.emailAccount.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputEmailAccount")];
        return;
    }
    if (![ToolUtil matchEmail:self.emailAccount.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputEmailValidateRight")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardLoading")];
    [MineNetManager bindingEmailCodeForEmail:self.emailAccount.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view ug_showToastWithToast:LocalizationKey(@"getEmailCodeTip")];
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
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }
    }];
}

//MARK:--绑定邮箱的点击事件
- (IBAction)bindingEmailBtnClick:(UIButton *)sender {
    if (self.bindingStatus == 0) {
        //绑定
        [self certainBinding];
    }else{
        //解绑
        NSLog(@"解绑邮箱");
    }
}
//MARK:--绑定邮箱接口调用
-(void)certainBinding{
    if ([self.emailAccount.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputEmailAccount")];
        return;
    }
    if (![ToolUtil matchEmail:self.emailAccount.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputEmailValidateRight")];
        return;
    }
    if ([self.emailCode.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputEmailValidate")];
        return;
    }
    if ([self.loginPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputLoginPassword")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    [MineNetManager bindingEmailForCode:self.emailCode.text withPassword:self.loginPassword.text withEmail:self.emailAccount.text CompleteHandle:^(id resPonseObj, int code) {
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
