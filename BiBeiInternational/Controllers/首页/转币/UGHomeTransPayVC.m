//
//  UGHomeTransPayVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeTransPayVC.h"
#import "UGGoogleVerifyVC.h"
#import "UGCheckJypasswordExistApi.h"
#import "UGReviseWalletPasswordVC.h"
#import "AppDelegate.h"
#import "UGNewPayApi.h"
#import "UGNewGoogleVerifyVC.h"

@interface UGHomeTransPayVC ()<GLCodeInputViewDelegate>
@property(nonatomic,assign)NSInteger time;
@end

@implementation UGHomeTransPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!UG_CheckStrIsEmpty(self.tradeAmount)) {
        self.price.text = [NSString stringWithFormat:@"%@ UG",self.tradeAmount];
    }
    if (!UG_CheckStrIsEmpty(self.aloginName)) {
        self.acceptUser.text =self.aloginName;
    }
    if (!UG_CheckStrIsEmpty(self.apayCardNo)) {
        self.address.text =self.apayCardNo;
    }
}


-(void)languageChange{
    self.title = @"请输入钱包支付密码";
    
    self.time = 0;
    
    if ([self.orderType isEqualToString:@"1"]) {
        self.serverchangeLabel.hidden = YES;
    }else{
        self.serverchangeLabel.hidden = NO;
    }
    self.serverchangeLabel.text = [NSString stringWithFormat:@"手续费: %@%@ ",self.chengePay,@"UG"];
}

-(void)jypassWord{
  
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self tureBtn:nil];
}

#pragma mark-确认
- (IBAction)tureBtn:(id)sender {
      [self.view endEditing:YES];
    if (UG_CheckStrIsEmpty(self.passWordInputView.textStore) || self.passWordInputView.textStore.length != 6) {
        [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
    }else{
        self.tureBtn.userInteractionEnabled = NO;
        UGCheckJypasswordExistApi *api = [[UGCheckJypasswordExistApi alloc] init];
        api.password = self.passWordInputView.textStore;
        @weakify(self);
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            @strongify(self);
            if (!apiError) {
                NSString *releaseLimit = [self upDataMessage:@"c2cLimit" WithMessage:@"1000"];
                if ([self.orderType isEqualToString:@"1"]) {
                    releaseLimit = [self upDataMessage:@"c2bLimit" WithMessage:@"1000"];
                }
                NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
                NSString *pricenu =  [NSString ug_positiveFormatWithMultiplier:self.tradeAmount multiplicand:cnyRate scale:6 roundingMode:NSRoundDown];
                if ( [pricenu doubleValue]  <= [releaseLimit doubleValue]) {
                    //限定值以内  不需要短信验证
                    [self pay];
                }else{
//                    [UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone = YES;
//                    [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone = @"189092739121";
                    if ([UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone) {
                        UGGoogleVerifyVC *verif = [[UGGoogleVerifyVC alloc] init];
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
                        verif.type = 1;
                        [self.navigationController pushViewController:verif animated:YES];
                    }else{
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
                            verif.passWords = self.passWordInputView.textStore;
                            verif.type = 1;
                            [self.navigationController pushViewController:verif animated:YES];
                        }
                    }
                }
            }else
            {
                 [self.view ug_showToastWithToast:apiError.desc];
            }
            self.tureBtn.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark -转币
-(void)pay{
    UGNewPayApi *api = [[UGNewPayApi alloc] init];
    api.version = @"1.0";//1.0支付接口版本号
    api.code = @"";//手机验证码
    api.sloginName = [UGManager shareInstance].hostInfo.username;//---用户登录名
    api.payPassword= self.passWordInputView.textStore;//??支付密码
    if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
         UGWalletAllModel *model =[UGManager shareInstance].hostInfo.userInfoModel.list[0];
         api.spayCardNo = model.address;//---支付UG钱包地址
    }
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
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"转币成功！"];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回首页 刷新UG钱包数据
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
        self.tureBtn.userInteractionEnabled = YES;
    }];
}


#pragma mark- 找回密码
- (IBAction)findBtn:(id)sender {
    [self.navigationController pushViewController:[UGReviseWalletPasswordVC new] animated:YES];
}


#pragma mark- 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
