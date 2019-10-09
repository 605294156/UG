//
//  UGLoginApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGLoginApi.h"

@implementation UGLoginApi
-(NSString *)requestUrl{
    return @"uc/login";
//      return @"/ug/login/mobileLogin";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.username) ? self.username:@"" forKey:@"username"];
    [argument setObject:!UG_CheckStrIsEmpty(self.password) ? self.password:@"" forKey:@"password"];
    [argument setObject:!UG_CheckStrIsEmpty(self.country) ? self.country:@"" forKey:@"country"];
    [argument setObject:!UG_CheckStrIsEmpty(self.areaCode) ? self.areaCode:@"" forKey:@"areaCode"];
    return argument;
}

@end
