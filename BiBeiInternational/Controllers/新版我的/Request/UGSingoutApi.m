//
//  UGSingoutApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSingoutApi.h"

@implementation UGSingoutApi

- (NSString *)requestUrl {
    return @"/ug/member/logout";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    NSString *access_auth_token = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
    [dict setObject:access_auth_token ? access_auth_token : @"" forKey:@"loginHeader"];
    return dict;
}

@end
