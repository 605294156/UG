//
//  UGOTCPayApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCPayApi.h"

@implementation UGOTCPayApi

- (NSString *)requestUrl {
//    return @"otc/order/pay";
    return @"/ug/otcv2/pay";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    [dict setObject:self.payMode forKey:@"payMode"];

    return dict;
}

@end
