//
//  UGAbleToValidApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAbleToValidApi.h"

@implementation UGAbleToValidApi
- (NSString *)requestUrl {
    return @"ug/member/ableToValid";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.username)?self.username:@"" forKey:@"username"];

    return dict;
}
@end

@implementation UGAbleValidModel


@end
