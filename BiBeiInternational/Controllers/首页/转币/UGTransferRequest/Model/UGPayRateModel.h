//
//  UGPayRateModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/**
 转币费率模型
 */
@interface UGPayRateModel : UGBaseModel
@property(nonatomic,copy)NSString *loginName;//付款人登录名
@property(nonatomic,copy)NSString *rateType;//手续费计算类型
@property(nonatomic,copy)NSString *payRate;//支付费率（无％)
@property(nonatomic,copy)NSString *payRateStr;//支付费率（有％）
@end

NS_ASSUME_NONNULL_END
