//
//  UGResetUserPassword.m
//  BiBeiInternational
//
//  Created by conew on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGResetUserPassword.h"

@implementation UGResetUserPassword
- (NSString *)requestUrl {
    return @"/ug/member/resetUserPassword";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject: ! UG_CheckStrIsEmpty(self.password)? self.password : @""  forKey:@"password"];
    [dict setObject: ! UG_CheckStrIsEmpty(self.auxiliaries)? self.auxiliaries : @""  forKey:@"auxiliaries"];
    [dict setObject: ! UG_CheckStrIsEmpty(self.type)? self.type : @""  forKey:@"type"];
    return dict;
}
@end
