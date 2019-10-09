//
//  UGUGJyRateApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGUGJyRateApi.h"

@implementation UGUGJyRateApi
- (NSString *)requestUrl {
    return @"/ug/otcv2/getUGJyRate";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    return dict;
}
@end
