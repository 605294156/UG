//
//  UGOTCReleaseApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCReleaseApi.h"

@implementation UGOTCReleaseApi

- (NSString *)requestUrl {
//    return @"ug/otc/release";
    return @"/ug/otcv2/release";
}

-(NSTimeInterval)requestTimeoutInterval{
    return 60;
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    [dict setObject:self.jyPassword forKey:@"jyPassword"];
    [dict setObject:self.googleCode forKey:@"googleCode"];
    return dict;
}

@end
