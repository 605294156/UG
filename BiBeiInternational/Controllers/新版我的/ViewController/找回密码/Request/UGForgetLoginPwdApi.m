//
//  UGForgetLoginPwdApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/22.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGForgetLoginPwdApi.h"

@implementation UGForgetLoginPwdApi
-(NSString *)requestUrl{
    return @"ug/member/forgetLoginPwd";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    [argument setObject:!UG_CheckStrIsEmpty(self.nPassword)?self.nPassword:@"" forKey:@"newPassword"];
    [argument setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    return argument;
}
@end
