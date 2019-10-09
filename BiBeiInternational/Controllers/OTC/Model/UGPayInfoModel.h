//
//  UGPayInfoModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGAlipayModel.h"
#import "UGBankInfoModel.h"
#import "UGWechatPayModel.h"
#import "UGUnionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayInfoModel : UGBaseModel

@property (nonatomic, strong) UGAlipayModel * alipay;
@property (nonatomic, strong) UGBankInfoModel * bankInfo;
@property (nonatomic, strong) UGWechatPayModel * wechatPay;
@property (nonatomic, strong) UGUnionModel * unionPay;
@property (nonatomic, copy) NSString * realName;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * commission;
@property (nonatomic, copy) NSString * memberId;

/**
 支付接口传入后用户选择的支付方式，已付款状态才有值
 
 alipay == 支付宝
 wechatPay == 微信
 bankInfo == 银行卡
union == 云闪付
 */
@property(nonatomic, strong) NSString *payMode;


@end

NS_ASSUME_NONNULL_END
