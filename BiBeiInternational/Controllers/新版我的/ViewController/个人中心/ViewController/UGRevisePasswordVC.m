//
//  UGRevisePasswordVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGRevisePasswordVC.h"
#import "UGButton.h"
#import "TXLimitedTextField.h"
#import "UGValidateGoogleApi.h"
//#import "UGRevisePasswordApi.h"
#import "UGNewUpdatePasswordApi.h"
#import "UGResetUserPassword.h"

@interface UGRevisePasswordVC ()

@property (weak, nonatomic) IBOutlet UGButton *confirmButton;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *nPasswordField;//新密码
@property (weak, nonatomic) IBOutlet TXLimitedTextField *rPasswordField;//重复新密码
@property (weak, nonatomic) IBOutlet TXLimitedTextField *codeField;//谷歌验证码
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;//用户名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameHeight;//用户名容器view高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHegiht;//顶部容器高度
@property (weak, nonatomic) IBOutlet UILabel *googleLabel;
@property (weak, nonatomic) IBOutlet UIView *googleLine;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyLabel;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *phoneTextLabel;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UIView *phoneLine;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation UGRevisePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title =  self.fromeLogin ? @"忘记密码" : @"重置密码";
    self.title =  @"重置密码";
    self.confirmButton.buttonStyle = UGButtonStyleBlue;

    CGFloat cellHeight = 43.0f;
    
    //非注册页面过来不需要输入用户名
    if (!self.fromeLogin) {
        self.userNameHeight.constant = 0.0f;
        self.topViewHegiht.constant -= cellHeight;
    }
    self.phoneTextLabel.text = !self.fromeLogin ?  [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone : @"";
    self.phoneLabel.text =!self.fromeLogin ? [NSString stringWithFormat:@"+%@",[UGManager shareInstance].hostInfo.userInfoModel.member.areaCode] : @"";
    //人脸识别后进来
    if (self.fromeFace) {
        self.googleLabel.hidden = YES;
        self.googleLine.hidden = YES;
        self.codeField.hidden = YES;
        self.verifyLabel.hidden =YES;
        self.verifyBtn.hidden = YES;
        
        self.phoneLine.hidden = YES;
        self.phoneTextLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.topViewHegiht.constant -= 2*cellHeight;
    }
    
    self.userNameLabel.text =!self.fromeLogin ? [UGManager shareInstance].hostInfo.username :( !UG_CheckStrIsEmpty(self.username) ? self.username : @"");
    
    //助记词修改登录密码
    if (self.fromAuxiliaries) {
        self.googleLabel.hidden = YES;
        self.googleLine.hidden = YES;
        self.codeField.hidden = YES;
        self.verifyLabel.hidden =YES;
        self.verifyBtn.hidden = YES;
        
        self.phoneLine.hidden = YES;
        self.phoneTextLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.topViewHegiht.constant -= 2*cellHeight;
    }
    
    
}

#pragma mark -获取验证码
- (IBAction)getVerifyCode:(id)sender {
    if (self.phoneTextLabel.text.length == 0 && !self.fromeFace) {
        [self.view ug_showToastWithToast:@"手机号不能为空"];
        return;
    }
    UGNewUpdatePasswordApi *revisePasswordApi = [UGNewUpdatePasswordApi new];
    revisePasswordApi.isVerify = YES;
    revisePasswordApi.phone = self.phoneTextLabel.text;
    revisePasswordApi.username =!self.fromeLogin ? [UGManager shareInstance].hostInfo.username :( !UG_CheckStrIsEmpty(self.username) ? self.username : @"");
    [revisePasswordApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self.view ug_showToastWithToast:apiError.desc];
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.verifyLabel.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            [self.view ug_showToastWithToast:@"短信发送成功 ！"];
        }
    }];
    [self timeCount];
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
                self.verifyLabel.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verifyLabel.hidden = NO;
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.verifyLabel.text = sStr;
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

//确定修改
- (IBAction)clickConfirm:(UGButton *)sender {
    
    if (self.nPasswordField.text.length == 0) {
        [self.view ug_showToastWithToast:@"新密码不能为空"];
        return;
    }
    
    if (![self.nPasswordField.text isEqualToString:self.rPasswordField.text]) {
        [self.view ug_showToastWithToast:@"请您确认两次输入密码一致！"];
        return;
    }
    
    if (self.nPasswordField.text.length <8 || self.nPasswordField.text.length>20) {
        [self.view ug_showToastWithToast:@"请输8-20位的登录密码"];
        return;
    }
    if (self.rPasswordField.text.length <8 || self.rPasswordField.text.length>20) {
        [self.view ug_showToastWithToast:@"重新输入不正确，请输8-20位的登录密码"];
        return;
    }
    if (![self judgePassWordLegal:self.nPasswordField.text]) {
        [self.view ug_showToastWithToast:@"密码必须包含字母、数字"];
        return;
    }
    if (![self judgePassWordLegal:self.rPasswordField.text]) {
        [self.view ug_showToastWithToast:@"重新输入不正确，密码必须包含字母、数字"];
        return;
    }
    
    if (self.fromAuxiliaries) {
        
        [self revisePasswordByAuxiliaries];
    }
    else
    {
        if (self.phoneTextLabel.text.length == 0 && !self.fromeFace) {
            [self.view ug_showToastWithToast:@"手机号不能为空"];
            return;
        }
        
        if (self.codeField.text.length == 0 && !self.fromeFace) {
            [self.view ug_showToastWithToast:@"验证码不能为空"];
            return;
        }
        
        if (self.userNameLabel.text.length == 0 && self.fromeLogin) {
            [self.view ug_showToastWithToast:@"用户名不能为空"];
            return;
        }
        
         [self revisePassword];
    }

    
   
    
//    //验证谷歌验证码
//    [self validateGoogleCode:^{
//        //再修改密码
//        [self revisePassword];
//    }];
    
}

//验证谷歌验证码
- (void)validateGoogleCode:(void(^)(void))completionBlock {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UGValidateGoogleApi *validateGoogleApi = [UGValidateGoogleApi new];
    validateGoogleApi.code = self.codeField.text;
    [validateGoogleApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if (completionBlock) {
                completionBlock();
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma - 助记词重置登录密码
-(void)revisePasswordByAuxiliaries
{
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGResetUserPassword *api = [[UGResetUserPassword alloc]init];
    api.password = self.nPasswordField.text;
    api.type = @"1";
    api.auxiliaries = self.auxiliaries;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            //更新保存的登录密码
            [[UGManager shareInstance] updatePasswordToSave:self.nPasswordField.text];
            [self.view ug_showToastWithToast:@"重置密码成功"];
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

//修改密码
- (void)revisePassword{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UGNewUpdatePasswordApi *revisePasswordApi = [UGNewUpdatePasswordApi new];
    revisePasswordApi.isVerify = NO;
    revisePasswordApi.nPassword = self.nPasswordField.text;
    revisePasswordApi.username =!self.fromeLogin ? [UGManager shareInstance].hostInfo.username :( !UG_CheckStrIsEmpty(self.username) ? self.username : @"");
    if (!self.fromeFace) {
        revisePasswordApi.code = self.codeField.text;
        revisePasswordApi.phone = self.phoneTextLabel.text;
    }else{
        revisePasswordApi.faceToken = !UG_CheckStrIsEmpty(self.faceCode) ? self.faceCode : @"";
    }
    [revisePasswordApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            //更新保存的登录密码
            [[UGManager shareInstance] updatePasswordToSave:self.nPasswordField.text];
            [self.view ug_showToastWithToast:@"重置密码成功 !"];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回首页 刷新UG钱包数据
                [weakSelf.navigationController popToViewController:self.topVC animated:YES];
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
