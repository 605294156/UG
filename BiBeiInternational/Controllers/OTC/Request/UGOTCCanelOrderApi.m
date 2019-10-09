//
//  UGOTCCanelOrderApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCCanelOrderApi.h"

@implementation UGOTCCanelOrderApi

- (NSString *)requestUrl {
//    return @"otc/order/cancel";
    return @"/ug/otcv2/cancel";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    return dict;
}

@end
