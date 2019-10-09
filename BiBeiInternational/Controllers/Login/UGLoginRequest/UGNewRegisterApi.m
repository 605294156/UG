//
//  UGNewRegisterApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGNewRegisterApi.h"

@implementation UGNewRegisterApi
-(NSString *)requestUrl{
    return @"ug/member/newRegister";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.areaCode) ? self.areaCode:@"" forKey:@"areaCode"];
    [argument setObject:!UG_CheckStrIsEmpty(self.mobilePhone) ? self.mobilePhone:@"" forKey:@"mobilePhone"];
    [argument setObject:!UG_CheckStrIsEmpty(self.country) ? self.country:@"" forKey:@"country"];
    [argument setObject:!UG_CheckStrIsEmpty(self.password) ? self.password:@"" forKey:@"password"];
    [argument setObject:!UG_CheckStrIsEmpty(self.code) ? self.code:@"" forKey:@"code"];
    return argument;
}
@end
