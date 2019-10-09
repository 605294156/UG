//
//  UGOtcvSendCodeApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGOtcvSendCodeApi.h"

@implementation UGOtcvSendCodeApi
-(NSString *)requestUrl{
    return @"ug/otcv2/sendCode";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
