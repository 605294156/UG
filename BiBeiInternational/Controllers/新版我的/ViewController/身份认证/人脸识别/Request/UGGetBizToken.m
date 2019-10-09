//
//  UGGetBizToken.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetBizToken.h"

@implementation UGGetBizToken

- (NSString *)requestUrl {
    return @"ug/application/getBizToken";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.target)? self.target : @"" forKey:@"target"];
    [dict setObject:!UG_CheckStrIsEmpty(self.username)? self.username : @"" forKey:@"username"];
    return dict;
}

@end
