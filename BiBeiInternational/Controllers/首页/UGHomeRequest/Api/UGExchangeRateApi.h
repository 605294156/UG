//
//  UGExchangeRateApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 获取汇率 法币对币币  币币对币币
 */
@interface UGExchangeRateApi : UGBaseRequest
@property(nonatomic,strong)NSString *urlArm;
@end
