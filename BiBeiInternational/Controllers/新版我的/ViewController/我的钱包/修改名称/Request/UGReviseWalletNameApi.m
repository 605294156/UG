//
//  UGReviseWalletNameApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReviseWalletNameApi.h"

@implementation UGReviseWalletNameApi

- (NSString *)requestUrl {
    return @"ug/member/wallet/updateWalletName";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.name forKey:@"name"];
    return dict;
}

@end
