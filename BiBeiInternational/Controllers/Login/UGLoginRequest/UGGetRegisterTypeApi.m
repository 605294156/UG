//
//  UGGetRegisterTypeApi.m
//  BiBeiInternational
//
//  Created by keniu on 2019/6/24.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetRegisterTypeApi.h"

@implementation UGGetRegisterTypeApi

-(NSString *)requestUrl{
    return @"ug/dictionary/findValue";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:@"registerUI" forKey:@"dicKey"];
    return argument;
}

@end
