//
//  UGOTCGoogleVerifyVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCGoogleVerifyVC.h"
#import "UGCodeInputView.h"
//#import "UGOTCReleaseApi.h"
#import "UGOTCNewRelease.h"
#import "OTCBuyViewController.h"
#import "UGOtcvSendCodeApi.h"
#import "UGOTCNewGoogleVerifyVC.h"

@interface UGOTCGoogleVerifyVC ()<GLCodeInputViewDelegate>

@property (weak, nonatomic) IBOutlet UGCodeInputView *passWordInputView;

@property (nonatomic, strong) NSString *messageID;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyLab;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *tishi;

@end

@implementation UGOTCGoogleVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机验证码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderFromUGNotifyListViewController:) name:@"通知消息列表进入订单详情操作" object:nil];
    
    self.phoneLabel.text = [UG_MethodsTool encryptionWord:[UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone];
    
    [self getCodeRequest];
    
    [self timeCount];
}

- (void)orderFromUGNotifyListViewController:(NSNotification *)notification {
    self.messageID = notification.object;
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self clickConfim:nil];
}

#pragma marek -获取验证码
- (IBAction)getVerifyCode:(id)sender {
    [self getCodeRequest];
    
    [self timeCount];
}

#pragma mark - 获取手机验证码
-(void)getCodeRequest{
    UGOtcvSendCodeApi *api = [[UGOtcvSendCodeApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self.view ug_showToastWithToast:apiError.desc];
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.verifyLab.hidden = YES;
                self.titile.hidden = YES;
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
                self.titile.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verifyLab.hidden = NO;
                self.titile.hidden = NO;
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.verifyLab.text = sStr;
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark- 确认
- (IBAction)clickConfim:(UIButton *)sender {
    if (self.passWordInputView.textStore.length == 6) {
        //放币请求
        [self sendRequest];
    } else {
        [self.view ug_showToastWithToast:@"请输入手机验证码！"];
    }

}

//支付请求
- (void)sendRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCNewRelease *api = [UGOTCNewRelease new];
    api.orderSn = self.orderSn;
    api.jyPassword = self.jyPassword;
    api.code = self.passWordInputView.textStore;
    api.validType = @"0";
    self.tureBtn.userInteractionEnabled = NO;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            //发送订单完成更改消息列表中的数据状态消息
            if (self.messageID.length > 0) {[[NSNotificationCenter defaultCenter] postNotificationName:@"订单完成更改消息列表中的数据状态" object:self.messageID];}
            //订单详情
            OTCBuyViewController *vc = [OTCBuyViewController new];
            vc.orderSn = self.orderSn;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [[UIApplication sharedApplication].keyWindow ug_showToastWithToast:apiError.desc];
        }
        self.tureBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark - 新增谷歌验证码的验证方式

- (IBAction)toUseGoogleVerifyCode:(id)sender {
    
    if ([self hasBindingGoogleValidator])
    {
        
        UGOTCNewGoogleVerifyVC *googleVerifyVC = [UGOTCNewGoogleVerifyVC new];
        googleVerifyVC.orderSn = self.orderSn;
        googleVerifyVC.jyPassword = self.jyPassword;
        [self.navigationController pushViewController:googleVerifyVC animated:YES];
    }
    
}

#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end
