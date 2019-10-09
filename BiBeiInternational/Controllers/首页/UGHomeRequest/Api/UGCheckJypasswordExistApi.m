//
//  UGCheckJypasswordExistApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGCheckJypasswordExistApi.h"

@implementation UGCheckJypasswordExistApi
-(NSString *)requestUrl{
    return @"ug/member/validJypassword";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    NSString * acount = [UGManager shareInstance].hostInfo.ID;
    [argument setObject:!UG_CheckStrIsEmpty(acount) ? acount:@"" forKey:@"account"];
    [argument setObject:!UG_CheckStrIsEmpty(self.password) ? self.password:@"" forKey:@"password"];
    return argument;
}
@end
