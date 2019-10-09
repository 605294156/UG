//
//  UGPayGoogleVerifyView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayGoogleVerifyView.h"
#import "UGCodeInputView.h"
#import "UGsendCodeApi.h"
#import "UGBindingGoogleVC.h"


@interface UGPayGoogleVerifyView ()<GLCodeInputViewDelegate>

@property (weak, nonatomic) IBOutlet UGCodeInputView *inputCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyLab;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property(nonatomic,assign) BOOL isGoogleVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *changeVerifyWayButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation UGPayGoogleVerifyView

+ (instancetype)fromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"UGPayGoogleVerifyView" owner:nil options:nil].firstObject;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillHideNotification object:nil];
    }
    @weakify(self);
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        self.phoneLabel.text =[UG_MethodsTool encryptionWord:[UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone];
    }];
    
    self.isGoogleVerifyCode = NO;
    
    [self getCodeRequest];
    
    [self timeCount];
    
    return self;
}

#pragma mark -获取手机验证码
- (IBAction)getVerifyCode:(id)sender {
    [self getCodeRequest];
    [self timeCount];
}

#pragma mark - 获取手机验证码
-(void)getCodeRequest{
    UGsendCodeApi *api = [[UGsendCodeApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self  ug_showToastWithToast:apiError.desc];
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.verifyLab.hidden = YES;
                self.titile.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            [self.superview ug_showToastWithToast:@"短信发送成功 ！"];
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
                self.titile.hidden = YES;
                self.verifyLab.text = @"";
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.isGoogleVerifyCode) {
                    self.verifyLab.hidden = YES;
                    self.titile.hidden = YES;
                }
                else
                {
                    self.verifyLab.hidden = NO;
                    self.titile.hidden = NO;
                }
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.verifyLab.text = sStr;
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}


- (void)keyBoardFrameChanged:(NSNotification* )notification {
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyBorardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    BOOL hidden = [notification.name isEqualToString:UIKeyboardWillHideNotification];
    
    [UIView animateWithDuration:duration delay:0 options:[self animationOptionsForCurve:curve] animations:^{
        //输入框的位置
        self.bottomConstraint.constant =  hidden  ? 0 : keyBorardHeight;
        
    } completion:nil];
}

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self clickDetermine:nil];
}

- (IBAction)clickDetermine:(UIButton *)sender {
    if (self.inputCodeView.textStore.length != 6) {
        if (self.isGoogleVerifyCode) {
             [self.superview ug_showToastWithToast:@"请输入谷歌验证码！"];
        }
        else
        {
             [self.superview ug_showToastWithToast:@"请输入手机验证码！"];
        }
        return;
    }

    if (self.determineHanlde) {
        
        if (self.isGoogleVerifyCode)
        {
         if ([UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation)
         {
             self.determineHanlde(self.inputCodeView.textStore,@"1");
         }
         else
        {
            [self toAlertUserBindTheGoogleVerification];
        }
                 
        }
        else
        {
         self.determineHanlde(self.inputCodeView.textStore,@"0");
        }
    }
}

- (IBAction)clickCose:(UIButton *)sender {
    if (self.clickCloseHandle) {
        self.clickCloseHandle();
    }
}
- (IBAction)changeVerifyTypeAction:(id)sender {
    self.isGoogleVerifyCode = !self.isGoogleVerifyCode;
    self.titile.hidden = self.isGoogleVerifyCode;
    self.phoneLabel.hidden = self.isGoogleVerifyCode;
    self.verifyBtn.hidden = self.isGoogleVerifyCode;
    self.verifyLab.hidden = self.isGoogleVerifyCode;
    if (self.isGoogleVerifyCode)
    {
        [self.changeVerifyWayButton setTitle:@"切换手机验证" forState:UIControlStateNormal];
        self.titleLabel.text = @"请输入谷歌验证码";
        if (![UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation)
        {
            [self toAlertUserBindTheGoogleVerification];
        }
    }
    else
    {
        [self.changeVerifyWayButton setTitle:@"切换谷歌验证" forState:UIControlStateNormal];
        self.titleLabel.text = @"请输入手机验证码";
    }
}

-(void)toAlertUserBindTheGoogleVerification
{
 [[NSNotificationCenter defaultCenter]postNotificationName:@"toAlertUserBindTheGoogleVerification" object:nil];
}

#pragma mark - 检查谷歌验证器绑定状态
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}


@end
