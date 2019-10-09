//
//  UGOrderDetailApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOrderDetailApi.h"

@implementation UGOrderDetailApi

- (NSString *)requestUrl {
//    return @"otc/order/detail";
    return @"/ug/otcv2/detail";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    return dict;
}

@end
