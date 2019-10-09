//
//  UGOTCGoogleVerifyVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCNewGoogleVerifyVC.h"
#import "UGCodeInputView.h"
//#import "UGOTCReleaseApi.h"
#import "UGOTCNewRelease.h"
#import "OTCBuyViewController.h"
#import "UGOtcvSendCodeApi.h"

@interface UGOTCNewGoogleVerifyVC ()<GLCodeInputViewDelegate>

@property (weak, nonatomic) IBOutlet UGCodeInputView *passWordInputView;
@property (nonatomic, strong) NSString *messageID;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;


@end

@implementation UGOTCNewGoogleVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"请输入谷歌验证码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderFromUGNotifyListViewController:) name:@"通知消息列表进入订单详情操作" object:nil];
    
}

- (void)orderFromUGNotifyListViewController:(NSNotification *)notification {
    self.messageID = notification.object;
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self clickConfim:nil];
}


#pragma mark- 确认
- (IBAction)clickConfim:(UIButton *)sender {
    if (self.passWordInputView.textStore.length == 6) {
        //放币请求
        [self sendRequest];
    } else {
        [self.view ug_showToastWithToast:@"请输入谷歌验证码！"];
    }

}

//支付请求
- (void)sendRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCNewRelease *api = [UGOTCNewRelease new];
    api.orderSn = self.orderSn;
    api.jyPassword = self.jyPassword;
    api.googleCode = self.passWordInputView.textStore;
    api.validType = @"1";
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

- (IBAction)toUsePhoneVerifyCode:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
