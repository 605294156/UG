//
//  UGInviteRegisterApi.m
//  BiBeiInternational
//
//  Created by keniu on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGInviteRegisterApi.h"

@implementation UGInviteRegisterApi
-(NSString *)requestUrl{
    return @"ug/acceptance/inviteRegister";
}

-(id)requestArgument{
    self.memberId = [UGManager shareInstance].hostInfo.ID;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument setObject:!UG_CheckStrIsEmpty(self.memberId)?self.memberId:@"" forKey:@"memberId"];
    [argument setObject:!UG_CheckStrIsEmpty(self.rate)?self.rate:@"" forKey:@"rate"];
    return argument;
}

@end
