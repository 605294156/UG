//
//  UGCancelAppealApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/5/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCancelAppealApi.h"

@implementation UGCancelAppealApi
- (NSString *)requestUrl {
    return @"/ug/otcv2/cancelAppeal";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    return dict;
}
@end
