//
//  UGAdvertiseDetailApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdvertiseDetailApi.h"

@implementation UGAdvertiseDetailApi

- (NSString *)requestUrl {
    return @"/otc/advertise/detail";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:self.advertiseId forKey:@"id"];
    return dict;
}

@end
