//
//  UGFindPassWordTureVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/22.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGFindPassWordTureVC.h"
#import "TXLimitedTextField.h"
#import "UGForgetLoginPwdApi.h"
#import "UGfindPasswordApi.h"
#import "UGResetUserPassword.h"


@interface UGFindPassWordTureVC ()
@property (weak, nonatomic) IBOutlet TXLimitedTextField *passwordFiled;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *rePassWordFiled;

@end

@implementation UGFindPassWordTureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    NSLog(@"auxiliaries = %@",self.auxiliaries);
    
    
}

#pragma mark -确认登录
- (IBAction)tureBtn:(id)sender {
    if (self.passwordFiled.text.length == 0) {
        [self.view ug_showToastWithToast:@"新密码不能为空"];
        return;
    }
    

    if (self.passwordFiled.text.length <8 || self.passwordFiled.text.length>20) {
        [self.view ug_showToastWithToast:@"请输8-20位的登录密码"];
        return;
    }
    if (![self judgePassWordLegal:self.passwordFiled.text]) {
        [self.view ug_showToastWithToast:@"密码必须包含字母、数字"];
        return;
    }
    if (![self.passwordFiled.text isEqualToString:self.rePassWordFiled.text]) {
        [self.view ug_showToastWithToast:@"请您确认两次输入密码一致！"];
        return;
    }
    if (self.rePassWordFiled.text.length <8 || self.rePassWordFiled.text.length>20) {
        [self.view ug_showToastWithToast:@"重新输入不正确，请输8-20位的登录密码"];
        return;
    }
    if (![self judgePassWordLegal:self.rePassWordFiled.text]) {
        [self.view ug_showToastWithToast:@"重新输入不正确，密码必须包含字母、数字"];
        return;
    }
    
    if (self.isFindLoginPassword) {
        [MBProgressHUD ug_showHUDToKeyWindow];
        UGfindPasswordApi *api  = [UGfindPasswordApi new];
        api.username = self.username;
        api.auxiliaries = self.auxiliaries;
        api.password = self.passwordFiled.text;
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            if (object) {
                [self.view ug_showToastWithToast:@"密码设置成功，请重新登录！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:self.topVC animated:YES];
                });
            }else{
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
        
    }
    else
    {
        [MBProgressHUD ug_showHUDToKeyWindow];
        UGForgetLoginPwdApi *api = [[UGForgetLoginPwdApi alloc] init];
        api.nPassword = self.passwordFiled.text;
        api.phone = self.phone;
        api.code = self.code;
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            if (object) {
                [self.view ug_showToastWithToast:@"密码设置成功，请重新登录！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:self.topVC animated:YES];
                });
            }else{
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    
    }
}

-(BOOL)judgePassWordLegal:(NSString *)pass{
    NSUInteger len = [pass length];
    BOOL isal = NO,isnum = NO,isxx = NO;
    for(int i=0;i<len;i++)
    {
        unichar a=[pass characterAtIndex:i];
        if (islower(a)) {//小写字母
            isal = YES;
        }
        if ((isupper(a))) {//大写字母
            isxx = YES;
        }
        if (isdigit(a)) {
            isnum = YES;
        }
        
    }
    return (isal || isxx) && isnum;
}


@end
