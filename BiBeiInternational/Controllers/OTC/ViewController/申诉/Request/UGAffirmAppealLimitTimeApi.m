//
//  UGAffirmAppealLimitTimeApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAffirmAppealLimitTimeApi.h"

@implementation UGAffirmAppealLimitTimeApi
- (NSString *)requestUrl {
    return @"/ug/otcv2/affirmAppealLimitTime";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
     [dict removeObjectForKey:@"id"];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    return dict;
}
@end
