//
//  UGsendCodeApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGsendCodeApi.h"

@implementation UGsendCodeApi
-(NSString *)requestUrl{
    return @"ug/pay/sendCode";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
