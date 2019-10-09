//
//  UGfindAuxiliariesByUsername.m
//  BiBeiInternational
//
//  Created by keniu on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGfindAuxiliariesByUsernameApi.h"

@implementation UGfindAuxiliariesByUsernameApi
-(NSString *)requestUrl{
    return @"ug/member/findAuxiliariesByUserName";
}
-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.username) ? self.username:@"" forKey:@"username"];
    return argument;
}
@end
