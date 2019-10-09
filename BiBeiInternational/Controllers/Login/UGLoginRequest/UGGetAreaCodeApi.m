//
//  UGGetAreaCodeApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetAreaCodeApi.h"

@implementation UGGetAreaCodeApi
-(NSString *)requestUrl{
    return @"ug/member/getAreaCode";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
