//
//  UGCoinToCoinApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/12.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/*
 * 获取币币之间的汇率
 */
@interface UGCoinToCoinApi : UGBaseRequest
@property(nonatomic,copy)NSString *fromUnit;//基础币
@property(nonatomic,copy)NSString *toUnit;//结算币

@end

NS_ASSUME_NONNULL_END
