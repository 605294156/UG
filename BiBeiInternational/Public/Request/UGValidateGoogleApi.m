//
//  UGValidateGoogleApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGValidateGoogleApi.h"

@implementation UGValidateGoogleApi

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.code.length > 0 ? self.code : @"" forKey:@"code"];
    return dict;
}

@end
