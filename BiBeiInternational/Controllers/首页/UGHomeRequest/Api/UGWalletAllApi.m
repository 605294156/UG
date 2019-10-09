//
//  UGWalletAllApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/25.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGWalletAllApi.h"

@interface UGWalletAllApi ()

@end

@implementation UGWalletAllApi

-(NSString *)requestUrl{
    return @"ug/member/wallet/all";
}

-(id)requestArgument{
    NSString * memberId = [UGManager shareInstance].hostInfo.ID;
    NSMutableDictionary *argument  = [super requestArgument];//如果有父类 确定参数 如 设备号 就先拿到父类的
    [argument setObject:!UG_CheckStrIsEmpty(memberId)? memberId : @"" forKey:@"memberId"];
    [argument setObject:@"UG" forKey:@"unit"];
    return argument;
}

@end
