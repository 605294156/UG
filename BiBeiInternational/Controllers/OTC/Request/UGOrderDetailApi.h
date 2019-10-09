//
//  UGOrderDetailApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOrderDetailApi : UGBaseRequest


/**
 订单号
 */
@property(nonatomic, strong) NSString *orderSn;

@end

NS_ASSUME_NONNULL_END
