//
//  UGMineInfoRequest.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMineInfoApi.h"
#import "UGManager.h"

@implementation UGMineInfoApi

- (NSString *)requestUrl {
    return @"/ug/member/detail";
}


- (id)requestArgument{
    //这里覆盖父类的参数，因为这里会涉及到登录成功获取用户信息。获取用户信息成功后才会赋值给UGManager.host
    NSMutableDictionary *argument  = [super requestArgument];
    [argument setObject:self.userId ? : @"" forKey:@"id"];
    return argument;
}


@end
