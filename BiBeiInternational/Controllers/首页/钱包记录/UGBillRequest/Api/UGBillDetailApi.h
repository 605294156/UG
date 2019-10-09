//
//  UGBillDetailApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取UG钱包记录列表详情
 */
@interface UGBillDetailApi : UGBaseRequest
@property (nonatomic, copy) NSString *orderType;//订单类型,0收入1支出
@property (nonatomic, copy) NSString *orderSn;//订单号
@end

NS_ASSUME_NONNULL_END
