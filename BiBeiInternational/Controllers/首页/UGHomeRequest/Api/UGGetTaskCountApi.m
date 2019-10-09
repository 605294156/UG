//
//  UGGetTaskCountApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetTaskCountApi.h"

@implementation UGGetTaskCountApi
-(NSString *)requestUrl{
    return @"ug/dispatchTask/getDispatchCount";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
