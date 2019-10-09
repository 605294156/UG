//
//  UGOTCPreApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCPreApi.h"

@implementation UGOTCPreApi

- (NSString *)requestUrl {
    return @"otc/order/pre";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict  setObject:self.advertiseId.length > 0 ? self.advertiseId : @"" forKey:@"advertiseId"];
    return dict;
}

@end
