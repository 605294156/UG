//
//  UGPayApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/15.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayApi.h"

@implementation UGPayApi


- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    //第三方唤醒支付才传入 ：iOS写死30 安卓31
    [dict setObject:@(30) forKey:@"source"];
    return dict;
}

@end
