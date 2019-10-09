//
//  UGUsernameLoginApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/6/24.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGUsernameLoginApi.h"

@implementation UGUsernameLoginApi
-(NSString *)requestUrl{
//    return @"ug/login/usernameLogin";
    return @"uc/usernameLogin";
}


-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.username) ? self.username:@"" forKey:@"username"];
    [argument setObject:!UG_CheckStrIsEmpty(self.password) ? self.password:@"" forKey:@"password"];
    return argument;
}
@end
