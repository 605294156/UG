//
//  UGOrder.h
//  UGPaySDK
//
//  Created by keniu on 2018/12/14.
//  Copyright © 2018 keniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGOrder : NSObject

@property (nonatomic, copy) NSString *version; //支付接口版本号  第三方app传入  必填
@property (nonatomic, copy) NSString *goodsName;//商品名称      第三方app传入   非必填
@property (nonatomic, copy) NSString *merchNo;  //商户号        第三方app传入  必填
@property (nonatomic, copy) NSString *orderSn;//第三方订单号        第三方app传入 必填
@property (nonatomic, copy) NSString *callBackUrl;//回调地址 第三方app传入 必填


@property (nonatomic, copy) NSString *aloginName;//accept用户登录名
@property (nonatomic, copy) NSString * apayCardNo;//accept支付UG钱包地址


@property (nonatomic, copy) NSString *extra; //附加信息 第三方app传入 非必填
@property (nonatomic, copy) NSString *payViewUrl;//回显地址 第三方app传入 非必填
@property (nonatomic, copy) NSString *timestamp;//当前时间点


@property (nonatomic, copy) NSString *sloginName;//send用户登录名（商户号）
@property (nonatomic, copy) NSString *spayCardNo;//send支付UG钱包地址


@property (nonatomic, copy) NSString *tradeAmount;//交易金额,单位UG tradeAmount = tradeUgNumber
@property (nonatomic, copy) NSString *tradeUgNumber;//交易金额

@end

NS_ASSUME_NONNULL_END
