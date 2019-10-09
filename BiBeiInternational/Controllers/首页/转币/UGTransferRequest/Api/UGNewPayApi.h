//
//  UGNewPayApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGNewPayApi : UGBaseRequest
@property (nonatomic, copy) NSString *version;//1.0支付接口版本号
@property (nonatomic,copy)NSString *code;//验证码
@property (nonatomic, copy) NSString *sloginName;//---用户登录名
@property (nonatomic,copy)NSString *payPassword;//??支付密码
@property (nonatomic, copy) NSString *spayCardNo;//---支付UG钱包地址
@property (nonatomic, copy) NSString *aloginName;//接收用户登录名
@property (nonatomic, copy) NSString *apayCardNo;//接收UG钱包地址
@property (nonatomic, copy) NSString *tradeAmount;//交易金额,单位UG
@property (nonatomic, copy) NSString *tradeUgNumber;//交易数量, ==交易金额
@property (nonatomic,copy)NSString *orderType;// 0 订单类型,0个人转帐订单1个人支付订单2商户转帐订单
@property (nonatomic,copy)NSString *merchNo;//商户号---
@property (nonatomic, copy) NSString *goodsName;//商品名称---
@property (nonatomic, copy) NSString *remark;//备注---
@property (nonatomic, copy) NSString *orderSn;//订单号---
@property (nonatomic, copy) NSString *source;//sdk  支付固定传 30
@property(nonatomic, strong) NSString *validType; //0 表示手机短信验证  1为谷歌验证
@property(nonatomic, copy) NSString *googleCode;
@end

NS_ASSUME_NONNULL_END
