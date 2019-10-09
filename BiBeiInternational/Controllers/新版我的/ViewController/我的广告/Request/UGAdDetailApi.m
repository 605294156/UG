//
//  UGAdDetailApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdDetailApi.h"

@implementation UGAdDetailApi
- (NSString *)requestUrl {
//  return @"ug/advertise/deal";
    return @"/ug/otcv2/advertiseDetail";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.ID)? self.ID : @"" forKey:@"id"];
    return dict;
}
@end
