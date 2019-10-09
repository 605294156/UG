//
//  UGPayRateApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 转币手续费api
 */
@interface UGPayRateApi : UGBaseRequest
@property(nonatomic,copy)NSString *rateType;//计算手续费类型（0 按费率，1按笔）
@property(nonatomic,copy)NSString *sloginName;//付款人登录名
@end

NS_ASSUME_NONNULL_END
