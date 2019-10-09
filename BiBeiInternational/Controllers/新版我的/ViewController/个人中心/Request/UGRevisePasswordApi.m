//
//  UGRevisePasswordApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGRevisePasswordApi.h"

@implementation UGRevisePasswordApi

- (NSString *)requestUrl {
    return @"ug/member/updatePassword";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.nPassword)?self.nPassword:@"" forKey:@"newPassword"];
    [dict setObject:!UG_CheckStrIsEmpty(self.googleCode)?self.googleCode:@"" forKey:@"googleCode"];
    [dict setObject:!UG_CheckStrIsEmpty(self.username)?self.username:@"" forKey:@"username"];
    [dict setObject:!UG_CheckStrIsEmpty(self.faceToken)?self.faceToken:@"" forKey:@"faceToken"];
    return dict;
}

@end
