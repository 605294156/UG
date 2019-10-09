//
//  UGNewUpdateMarketPasswordApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGNewUpdateMarketPasswordApi.h"

@implementation UGNewUpdateMarketPasswordApi

- (NSString *)requestUrl {
    return @"ug/member/newUpdateMarketPassword";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    if (!self.isVerify) {
        //修改支付密码
        [dict setObject:!UG_CheckStrIsEmpty(self.nPassword)?self.nPassword:@"" forKey:@"newPassword"];
        [dict setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
        if (!UG_CheckStrIsEmpty(self.bizToken)) {
            [dict setObject:self.bizToken forKey:@"bizToken"];
        }
    }
    return dict;
}
@end
