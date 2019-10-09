//
//  UGGeneralVlidApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGGeneralValidApi.h"

@implementation UGGeneralValidApi

- (NSString *)requestUrl {
    return @"/ug/application/updateRealnameValid";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.realname forKey:@"realname"];
    [dict setObject:self.idCard forKey:@"idCard"];
    return dict;
}

@end
