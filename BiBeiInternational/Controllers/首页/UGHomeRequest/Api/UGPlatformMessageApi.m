//
//  UGPlatformMessageApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPlatformMessageApi.h"

@implementation UGPlatformMessageApi
-(NSString *)requestUrl{
    return @"ug/notice/findAll";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
