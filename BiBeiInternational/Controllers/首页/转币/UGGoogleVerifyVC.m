//
//  UGGoogleVerifyVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGGoogleVerifyVC.h"
#import "UGCodeInputView.h"
//#import "UGTransferApi.h"
#import "UGNewPayApi.h"
#import "UGWalletAllModel.h"
#import "UGsendCodeApi.h"
#import "UGNewGoogleVerifyVC.h"

@interface UGGoogleVerifyVC ()<GLCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *tishi;
@property (weak, nonatomic) IBOutlet UGCodeInputView *passWordInputView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyLab;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (nonatomic,strong)UGWalletAllModel *model;


@end

@implementation UGGoogleVerifyVC

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
    
    self.phoneLabel.text =[UG_MethodsTool encryptionWord:[UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone];
    
    [self getCodeRequest];
    
    [self timeCount];
}

-(void)languageChange{
    self.title = @"手机验证";
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self tureBtn:nil];
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

#pragma mark - 获取手机验证码
- (IBAction)getVerifyCode:(id)sender {
    [self getCodeRequest];
    [self timeCount];
}

#pragma mark - 获取手机验证码
-(void)getCodeRequest{
    UGsendCodeApi *api = [[UGsendCodeApi alloc] init];
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
        }
    }];
}

#pragma MARK - 确定
- (IBAction)tureBtn:(id)sender {
    if (!UG_CheckStrIsEmpty(self.passWordInputView.textStore)&& self.passWordInputView.textStore.length==6) {
        [self pay];
    }else {
        [self.view ug_showToastWithToast:@"请输入手机验证码！"];
    }
}

#pragma mark -转币
-(void)pay{
    UGNewPayApi *api = [[UGNewPayApi alloc] init];
    api.version = @"1.0";//1.0支付接口版本号
    api.code = self.passWordInputView.textStore;//手机验证码
    api.validType = @"0";
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

#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 新增谷歌验证码的验证方式

- (IBAction)toUseGoogleVerifyCode:(id)sender {
    
    if ([self hasBindingGoogleValidator])
    {
        UGNewGoogleVerifyVC *verif = [[UGNewGoogleVerifyVC alloc] init];
        verif.aloginName = self.aloginName;
        verif.apayCardNo = self.apayCardNo;
        verif.tradeAmount = self.tradeAmount;
        verif.tradeUgNumber= self.tradeUgNumber;
        verif.passWords = self.passWordInputView.textStore;
        verif.remark = self.remark;
        verif.orderType = self.orderType;
        verif.merchNo= self.merchNo;
        verif.extra = self.extra;
        verif.orderSn = self.orderSn;
        verif.passWords = self.passWords;
        [self.navigationController pushViewController:verif animated:YES];
    }
    
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}
@end
