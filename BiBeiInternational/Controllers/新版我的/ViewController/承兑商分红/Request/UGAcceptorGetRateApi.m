//
//  UGAcceptorGetRateApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAcceptorGetRateApi.h"

@implementation UGAcceptorGetRateApi
- (NSString *)requestUrl {
    return @"/ug/acceptor/get/rate";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    NSString * memberId = [UGManager shareInstance].hostInfo.ID;
    [dict setObject: memberId forKey:@"memberId"];
    return dict;
}
@end
