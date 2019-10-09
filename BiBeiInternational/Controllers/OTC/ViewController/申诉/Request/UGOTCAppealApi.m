//
//  UGOTCAppealApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/9.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCAppealApi.h"

@implementation UGOTCAppealApi

- (NSString *)requestUrl {
//    return @"otc/order/appeal";
    return @"/ug/otcv2/appeal";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    [dict setObject:self.remark forKey:@"remark"];
    [dict setObject:self.mobile forKey:@"mobile"];
    [dict setObject:self.areaCode forKey:@"areaCode"];
    [dict setObject:self.country forKey:@"country"];
    [dict setObject:self.imgUrls.length > 0 ? self.imgUrls : @"" forKey:@"imgUrls"];
    [dict setObject:self.appealRealName forKey:@"appealRealName"];
    return dict;
}

@end
