//
//  UGDeleteADApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGDeleteADApi.h"

@implementation UGDeleteADApi

- (NSString *)requestUrl {
//    return @"/otc/advertise/delete";
    return @"/ug/otcv2/delete";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:self.advertiseId forKey:@"advertiseId"];
    return dict;
}

@end
