//
//  UGGoogleVerifyVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGNewGoogleVerifyVC.h"
#import "UGCodeInputView.h"
//#import "UGTransferApi.h"
#import "UGNewPayApi.h"
#import "UGWalletAllModel.h"
#import "UGsendCodeApi.h"
#import "UGOTCNewRelease.h"
#import "OTCBuyViewController.h"

@interface UGNewGoogleVerifyVC ()<GLCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (weak, nonatomic) IBOutlet UILabel *tishi;
@property (weak, nonatomic) IBOutlet UGCodeInputView *passWordInputView;
@property (nonatomic,strong)UGWalletAllModel *model;
@property (weak, nonatomic) IBOutlet UIView *bgqtView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneTips;
@property (nonatomic, strong) NSString *messageID;

@end

@implementation UGNewGoogleVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
        self.model =[UGManager shareInstance].hostInfo.userInfoModel.list[0];
    }
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
            self.model =[UGManager shareInstance].hostInfo.userInfoModel.list[0];
        }
    }];
    
    [self languageChange];
    
    self.bgqtView.hidden = ![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
    self.phoneBtn.hidden = ![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
    self.phoneTips.hidden = ![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone;
    
    if (self.type==2) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderFromUGNotifyListViewController:) name:@"通知消息列表进入订单详情操作" object:nil];
    }
}

- (void)orderFromUGNotifyListViewController:(NSNotification *)notification {
    self.messageID = notification.object;
}

-(void)languageChange{
    self.title = @"谷歌验证";
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self tureBtn:nil];
}


#pragma MARK - 确定
- (IBAction)tureBtn:(id)sender {
    if (!UG_CheckStrIsEmpty(self.passWordInputView.textStore)&& self.passWordInputView.textStore.length==6) {
        if (self.type==1) {
            [self pay];
        }else if (self.type==2){
            [self sendRequest];
        }
    }else {
        [self.view ug_showToastWithToast:@"请输入谷歌验证码！"];
    }
}

#pragma mark -转币
-(void)pay{
    UGNewPayApi *api = [[UGNewPayApi alloc] init];
    api.version = @"1.0";//1.0支付接口版本号
    api.googleCode = self.passWordInputView.textStore;//谷歌验证码
    api.validType = @"1";
    api.sloginName = [UGManager shareInstance].hostInfo.username;//---用户登录名
    api.payPassword= self.passWords;//??支付密码
    api.spayCardNo = self.model.address;//---支付UG钱包地址
    api.aloginName = self.aloginName;//接收用户登录名
    api.apayCardNo = self.apayCardNo;//接收UG钱包地址
    api.tradeAmount = self.tradeAmount;//交易金额,单位UG
    api.tradeUgNumber = self.tradeUgNumber;//交易数量, ==交易金额
    api.remark = self.remark;//附言
    api.orderType =self.orderType;// 0 订单类型,0个人转帐订单1个人支付订单2商户转帐订单
    if ([self.orderType isEqualToString:@"1"]) {
        api.merchNo = self.merchNo;
        api.orderSn = self.orderSn;
        api.goodsName = @"ug";
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tureBtn.userInteractionEnabled = NO;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"转币成功！"];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回首页 刷新UG钱包数据
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
        self.tureBtn.userInteractionEnabled = YES;
    }];
}

//支付请求
- (void)sendRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCNewRelease *api = [UGOTCNewRelease new];
    api.orderSn = self.orderSn;
    api.jyPassword = self.passWords;
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
