//
//  UGfindPasswordApi.m
//  BiBeiInternational
//
//  Created by keniu on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGfindPasswordApi.h"

@implementation UGfindPasswordApi
-(NSString *)requestUrl{
    return @"ug/member/findPassword";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.username)?self.username:@"" forKey:@"username"];
    [argument setObject:!UG_CheckStrIsEmpty(self.password)?self.password:@"" forKey:@"password"];
    [argument setObject:!UG_CheckStrIsEmpty(self.auxiliaries)?self.auxiliaries:@"" forKey:@"auxiliaries"];
    return argument;
}
@end
