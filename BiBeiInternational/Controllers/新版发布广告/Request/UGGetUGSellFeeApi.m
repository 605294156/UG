//
//  UGGetUGSellFeeApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetUGSellFeeApi.h"

@implementation UGGetUGSellFeeApi
- (NSString *)requestUrl {
    return @"ug/otcv2/getUGSellFee";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    return dict;
}
@end
