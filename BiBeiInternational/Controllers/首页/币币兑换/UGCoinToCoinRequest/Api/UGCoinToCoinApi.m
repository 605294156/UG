//
//  UGCoinToCoinApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/12.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGCoinToCoinApi.h"

@implementation UGCoinToCoinApi
-(NSString *)requestUrl{
  return @"market/exchange-rate/exchangeRate";
}

-(id)requestArgument{
 NSMutableDictionary *argument  = [NSMutableDictionary new];
 //后台改了一次 所以 对应的参数 做了调换
 [argument setObject:!UG_CheckStrIsEmpty(self.toUnit)?self.toUnit:@"" forKey:@"fromUnit"];
 [argument setObject:!UG_CheckStrIsEmpty(self.fromUnit)?self.fromUnit:@"" forKey:@"toUnit"];
 return argument;
}

@end
