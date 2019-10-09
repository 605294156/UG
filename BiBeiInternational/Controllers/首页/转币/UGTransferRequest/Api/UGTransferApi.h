//
//  UGTransferApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 转币api
 */
@interface UGTransferApi : UGBaseRequest
@property (nonatomic, copy) NSString *version;//1.0支付接口版本号
@property (nonatomic,copy)NSString *googleCode;//已绑定  ---谷歌验证码
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
@end
