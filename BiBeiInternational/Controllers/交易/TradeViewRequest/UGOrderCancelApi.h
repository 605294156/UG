//
//  UGOrderCancelApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 取消委托单 --撤单
 */
@interface UGOrderCancelApi : UGBaseRequest
@property(nonatomic,copy)NSString *orderId;//委托单号
@end

NS_ASSUME_NONNULL_END
