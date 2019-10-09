//
//  UGRegisterApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGRegisterApi.h"

@implementation UGRegisterApi
-(NSString *)requestUrl{
    return @"ug/member/register";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.username)?self.username:@"" forKey:@"username"];
    [argument setObject:!UG_CheckStrIsEmpty(self.password)?self.password:@"" forKey:@"password"];
    return argument;
}
@end
