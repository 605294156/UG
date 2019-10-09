//
//  UGNewUpdatePasswordApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGNewUpdatePasswordApi.h"

@implementation UGNewUpdatePasswordApi
- (NSString *)requestUrl {
    return @"ug/member/newUpdatePassword";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    [dict setObject:!UG_CheckStrIsEmpty(self.username)?self.username:@"" forKey:@"username"];
    if (!self.isVerify) {
        //修改密码
        [dict setObject:!UG_CheckStrIsEmpty(self.nPassword)?self.nPassword:@"" forKey:@"newPassword"];
        [dict setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
        [dict setObject:!UG_CheckStrIsEmpty(self.faceToken)?self.faceToken:@"" forKey:@"faceToken"];
    }
    return dict;
}
@end
