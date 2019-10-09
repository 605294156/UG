//
//  UGForgetLoginPwdAuthApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/22.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGForgetLoginPwdAuthApi.h"

@implementation UGForgetLoginPwdAuthApi
-(NSString *)requestUrl{
    return @"ug/member/forgetLoginPwdAuth";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    [argument setObject:!UG_CheckStrIsEmpty(self.areaCode)?self.areaCode:@"" forKey:@"areaCode"];
     [argument setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    return argument;
}
@end
