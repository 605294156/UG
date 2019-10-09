//
//  UGReviseJYpasswordApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReviseJYpasswordApi.h"

@implementation UGReviseJYpasswordApi

- (NSString *)requestUrl {
    return @"ug/member/updateMarketPassword";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:!UG_CheckStrIsEmpty(self.nPassword)? self.nPassword : @""  forKey:@"newPassword"];
    if (!UG_CheckStrIsEmpty(self.bizToken)) {
        [dict setObject:self.bizToken forKey:@"bizToken"];
    }
    else if (!UG_CheckStrIsEmpty(self.code)) {
        [dict setObject:self.code forKey:@"code"];
    }
    return dict;
}

@end
