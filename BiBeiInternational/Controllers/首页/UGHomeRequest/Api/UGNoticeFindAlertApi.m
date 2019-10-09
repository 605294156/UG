//
//  UGNoticeFindAlertApi.m
//  BiBeiInternational
//
//  Created by keniu on 2019/5/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGNoticeFindAlertApi.h"

@implementation UGNoticeFindAlertApi

-(NSString *)requestUrl
{
    return @"ug/notice/findAlert";
}


-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
