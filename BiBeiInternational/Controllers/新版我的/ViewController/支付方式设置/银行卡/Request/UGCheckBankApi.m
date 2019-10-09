//
//  UGCheckBankApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGCheckBankApi.h"

@implementation UGCheckBankApi
- (NSString *)requestUrl {
    return  @"ug/bank/findAllBankWithSort";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    return dict;
}
@end
