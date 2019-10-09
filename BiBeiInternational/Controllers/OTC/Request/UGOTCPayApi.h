//
//  UGOTCPayApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCPayApi : UGBaseRequest

@property(nonatomic, strong) NSString *orderSn;

/**
 alipay
 wechatPay
 bankInfo
 */
@property(nonatomic, strong) NSString *payMode;

@end

NS_ASSUME_NONNULL_END
