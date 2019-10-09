//
//  UGUnbindPayModelApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/6/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGUnbindPayModelApi.h"

@implementation UGUnbindPayModelApi

- (NSString *)requestUrl {
    return @"ug/member/unbindPayModel";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    if ( ! UG_CheckStrIsEmpty(self.unbindWechat)) {
          [dict setObject:self.unbindWechat forKey:@"unbindWechat"];
    }
    if ( ! UG_CheckStrIsEmpty(self.unbindAliPay)) {
        [dict setObject:self.unbindAliPay forKey:@"unbindAliPay"];
    }
    if ( ! UG_CheckStrIsEmpty(self.unbindUnionPay)) {
        [dict setObject:self.unbindUnionPay forKey:@"unbindUnionPay"];
    }
    return dict;
}
@end
