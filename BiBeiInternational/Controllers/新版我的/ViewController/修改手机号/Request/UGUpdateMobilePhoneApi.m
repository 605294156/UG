//
//  UGUpdateMobilePhoneApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGUpdateMobilePhoneApi.h"

@implementation UGUpdateMobilePhoneApi
-(NSString *)requestUrl{
    return @"ug/member/updateMobilePhone";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
     [argument setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    [argument setObject:!UG_CheckStrIsEmpty(self.areaCode)?self.areaCode:@"" forKey:@"areaCode"];
    if (!self.isVerify) {
        //修改密码
        [argument setObject:!UG_CheckStrIsEmpty(self.country)?self.country:@"" forKey:@"country"];
        [argument setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    }
    return argument;
}
@end
