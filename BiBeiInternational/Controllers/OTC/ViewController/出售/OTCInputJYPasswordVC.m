//
//  OTCInputJYPasswordVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCInputJYPasswordVC.h"
#import "UGCodeInputView.h"
#import "UGCheckJypasswordExistApi.h"
#import "UGOTCGoogleVerifyVC.h"
#import "NSString+DecimalNumber.h"
#import "UGOTCNewRelease.h"
#import "OTCBuyViewController.h"

@interface OTCInputJYPasswordVC ()<GLCodeInputViewDelegate>

@property (weak, nonatomic) IBOutlet UGCodeInputView *jyPassWordView;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (nonatomic, strong) NSString *messageID;

@end

@implementation OTCInputJYPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"钱包支付密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *releaseLimit = [self upDataMessage:@"releaseLimit" WithMessage:@"1000"];
    NSString *pricenu = [NSString ug_positiveFormatWithMultiplier:self.orderModel.amount multiplicand:self.orderModel.price scale:6 roundingMode:NSRoundDown];
    if ( [pricenu doubleValue]  <= [releaseLimit doubleValue]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderFromUGNotifyListViewController:) name:@"通知消息列表进入订单详情操作" object:nil];
    }
}
    
- (void)orderFromUGNotifyListViewController:(NSNotification *)notification {
    self.messageID = notification.object;
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self tureBtn:nil];
}

- (IBAction)tureBtn:(id)sender {
    if (UG_CheckStrIsEmpty(self.jyPassWordView.textStore) || self.jyPassWordView.textStore.length != 6) {
        [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
    }else{
        [MBProgressHUD ug_showHUDToKeyWindow];
        UGCheckJypasswordExistApi *api = [[UGCheckJypasswordExistApi alloc] init];
        api.password = self.jyPassWordView.textStore;
        self.tureBtn.userInteractionEnabled = NO;
        @weakify(self);
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            @strongify(self);
            if (!apiError) {
                [self goToVerify];
            } else {
                [self.view ug_showToastWithToast:apiError.desc];
            }
            self.tureBtn.userInteractionEnabled = YES;
        }];
    }
}

-(void)goToVerify{
    NSString *releaseLimit = [self upDataMessage:@"releaseLimit" WithMessage:@"1000"];
    NSString *pricenu = [NSString ug_positiveFormatWithMultiplier:self.orderModel.amount multiplicand:self.orderModel.price scale:6 roundingMode:NSRoundDown];
    if ( [pricenu doubleValue]  <= [releaseLimit doubleValue]) {
      //限定值以内  不需要短信验证
        [self sendRequest];
    }else{
        //超过限定值 需要短信验证
        UGOTCGoogleVerifyVC *googleVerifyVC = [UGOTCGoogleVerifyVC new];
        googleVerifyVC.orderSn = self.orderSn;
        googleVerifyVC.jyPassword = self.jyPassWordView.textStore;
        [self.navigationController pushViewController:googleVerifyVC animated:YES];
    }
}

//支付请求
- (void)sendRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCNewRelease *api = [UGOTCNewRelease new];
    api.orderSn = self.orderSn;
    api.jyPassword = self.jyPassWordView.textStore;
    api.code = @"";
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
    }];
}
    
#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
    
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
