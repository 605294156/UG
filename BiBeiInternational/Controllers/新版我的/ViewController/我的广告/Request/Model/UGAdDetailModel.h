//
//  UGAdDetailModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGOTCAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAdDetailModel : UGBaseModel

@property (nonatomic, copy) NSString *ID;//广告的id
@property (nonatomic, copy) NSString *advertiseType;
@property (nonatomic, copy) NSString *isAuto;
@property (nonatomic, copy) NSString *autoword;
@property (nonatomic, copy) NSString *coinUnit;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *dealAmount;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *limitMoney;
@property (nonatomic, copy) NSString *maxLimit;//最大限额
@property (nonatomic, copy) NSString *minLimit;//最小限额
@property (nonatomic, copy) NSString *number; //数量
@property (nonatomic, copy) NSString *payMode;//支付的方式
@property (nonatomic, copy) NSString *premiseRate;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *priceType;
@property (nonatomic, copy) NSString *remainAmount;//剩余数量
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *status; //广告的状态   0上架  1下架
@property (nonatomic, copy) NSString *timeLimit;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *coinId;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberAvatar;
@property (nonatomic, strong)NSArray *order;

@property (nonatomic, copy) NSString *cardMember;
@property (nonatomic, copy) NSString *feeRate;
@property (nonatomic, copy) NSString *frozenAmount;
@property (nonatomic, copy) NSString *remainFrozenAmount;

/**
 *数据展示
 */
@property (nonatomic, strong)UGOTCAdModel *adModel;

/**
 *0  用户购买  1 系统回购
 */
@property (nonatomic, copy)NSString *sysBuy;

-(void)replaceAdModel;

@end

@interface UGAdDetailListModel : UGBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *advertiseId;//广告的id
@property (nonatomic, copy) NSString *advertiseType;
@property (nonatomic, copy) NSString *aliNo;
@property (nonatomic, copy) NSString *qrCodeUrl;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *cancelTime;
@property (nonatomic, copy) NSString *commission;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *createTime;  //订单时间
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName; //对方的用户名
@property (nonatomic, copy) NSString *customerRealName;
@property (nonatomic, copy) NSString *maxLimit;//最大限额
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *memberRealName;
@property (nonatomic, copy) NSString *minLimit;//最小限额
@property (nonatomic, copy) NSString *money; 
@property (nonatomic, copy) NSString *number; //数量
@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) UGOTCPayDetailModel *payMode;//支付的方式
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *referenceNumber;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *status; //订单状态    0：已取消   1：未付款    2：已付款    3：已完成   4：申诉中
@property (nonatomic, copy) NSString *timeLimit;
@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *qrWeCodeUrl;
@property (nonatomic, copy) NSString *wechat;

@property (nonatomic, copy) NSString *coinId;

@property (nonatomic, copy) NSString *avatar;

-(NSString *)statusStr;

- (NSString *)stautsConvertToImageStr;

@end

NS_ASSUME_NONNULL_END
