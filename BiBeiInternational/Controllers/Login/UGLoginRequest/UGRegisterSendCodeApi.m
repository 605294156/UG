//
//  UGRegisterSendCodeApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/19.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGRegisterSendCodeApi.h"

@implementation UGRegisterSendCodeApi
-(NSString *)requestUrl{
    return @"ug/member/sendCode";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.areaCode)?self.areaCode:@"" forKey:@"areaCode"];
    [argument setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    [argument setObject:!UG_CheckStrIsEmpty(self.geetest_seccode)?self.geetest_seccode:@"" forKey:@"geetest_seccode"];
    [argument setObject:!UG_CheckStrIsEmpty(self.geetest_validate)?self.geetest_validate:@"" forKey:@"geetest_validate"];
    [argument setObject:!UG_CheckStrIsEmpty(self.geetest_challenge)?self.geetest_challenge:@"" forKey:@"geetest_challenge"];
    return argument;
}
@end
