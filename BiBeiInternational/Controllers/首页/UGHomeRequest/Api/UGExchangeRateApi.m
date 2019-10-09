//
//  UGExchangeRateApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGExchangeRateApi.h"

@implementation UGExchangeRateApi
-(NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@",@"market/exchange-rate/",!UG_CheckStrIsEmpty(self.urlArm)?self.urlArm:@""];
}
@end
