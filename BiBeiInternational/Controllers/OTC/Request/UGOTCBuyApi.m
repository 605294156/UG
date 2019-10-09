//
//  UGOTCBuyApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCBuyApi.h"

@implementation UGOTCBuyApi

- (NSString *)requestUrl {
//    return self.isBuy ? @"otc/order/buy" : @"otc/order/sell";
     return self.isBuy ? @"/ug/otcv2/buy" : @"/ug/otcv2/sell";
}

-(NSTimeInterval)requestTimeoutInterval{
    return 60;
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    if (!UG_CheckStrIsEmpty(self.advertisingId)) {
        [dict setObject:self.advertisingId forKey:@"advertiseId"];
    }
//    if (!UG_CheckStrIsEmpty(self.coinId)) {
//         [dict setObject:self.coinId forKey:@"coinId"];
//    }
//    if (!UG_CheckStrIsEmpty(self.price)) {
//        [dict setObject:self.price forKey:@"price"];
//    }
    if (!UG_CheckStrIsEmpty(self.money)) {
        [dict setObject:self.money forKey:@"money"];
    }
    if (!UG_CheckStrIsEmpty(self.amount)) {
        [dict setObject:self.amount forKey:@"amount"];
    }
   return dict;
}

@end
