//
//  UGOrderWaitingDealListApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGOrderWaitingDealListApi.h"

@implementation UGOrderWaitingDealListApi
- (NSString *)requestUrl {
    return @"ug/otc/orderWaitingDealList";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    return dict;
}

@end
