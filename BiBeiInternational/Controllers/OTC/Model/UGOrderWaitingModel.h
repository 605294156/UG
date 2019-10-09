//
//  UGOrderWaitingModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGOTCPayDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOrderWaitingModel : UGBaseModel
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *customerQrCodeUrl;
@property (nonatomic, copy) NSString *qrCodeUrl;//支付宝二维码url
@property (nonatomic, copy) NSString *customerWechat;
@property (nonatomic, copy) NSString *customerCardNo;
@property (nonatomic, copy) NSString *customerRealName;//交易对象用户名
@property (nonatomic, copy) NSString *advertiseType;//广告类型 0:买入 1:卖出
@property (nonatomic, copy) NSString *country; //国家
@property (nonatomic, copy) NSString *memberRealName;//广告拥有者实际姓名
@property (nonatomic, copy) NSString *payTime;//付款时间
@property (nonatomic, copy) NSString *remark;//顾客需求
@property (nonatomic, copy) NSString *coinName;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *customerId;//交易对象id
@property (nonatomic, copy) NSString *memberName;//广告拥有者姓名
@property (nonatomic, copy) NSString *cardNo;//银行卡号
@property (nonatomic, copy) NSString *qrWeCodeUrl;//微信收款二维码
@property (nonatomic, copy) NSString *wechat;//微信号
@property (nonatomic, copy) NSString *payMode;//付费方式
@property (nonatomic, copy) NSString *advertiseDeductMoney;
@property (nonatomic, copy) NSString *version;//版本
@property (nonatomic, copy) NSString *tradeUserName;//交易对方用户名
@property (nonatomic, copy) NSString *number;//交易数量
@property (nonatomic, copy) NSString *branch;//支行
@property (nonatomic, copy) NSString *minLimit;//最低单笔交易额
@property (nonatomic, copy) NSString *releaseTime;//放行时间
@property (nonatomic, copy) NSString *coinId;//币种
@property (nonatomic, copy) NSString *bank;//银行
@property (nonatomic, copy) NSString *customerName;//交易对象用户名
@property (nonatomic, copy) NSString *timeLimit;//付款期限，单位分钟
@property (nonatomic, copy) NSString *customerAliNo;
@property (nonatomic, copy) NSString *cancelTime;
@property (nonatomic, copy) NSString *force;//1 需强制执行完 0 不需要强制
@property (nonatomic, copy) NSString *aliNo;//支付宝帐号
@property (nonatomic, copy) NSString *status;//类型(序数,字符)
@property (nonatomic, copy) NSString *price;//价格
@property (nonatomic, copy) NSString *memberId;//广告拥有者id
@property (nonatomic, copy) NSString *commission;//手续费
@property (nonatomic, copy) NSString *orderSn;//订单号
@property (nonatomic, copy) NSString *avatar;//交易对方头像
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *customerBranch;
@property (nonatomic, copy) NSString *customerQrWeCodeUrl;
@property (nonatomic, copy) NSString *referenceNumber;//付款参考号
@property (nonatomic, copy) NSString *money;//交易金额
@property (nonatomic, copy) NSString *maxLimit;//最高单笔交易额
@property (nonatomic, copy) NSString *orderPayMode;
@property (nonatomic, copy) NSString *customerBank;
@property (nonatomic, copy) NSString *advertiseId;

@end

NS_ASSUME_NONNULL_END
