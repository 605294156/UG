//
//  UGGetIntegrationRuleApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetIntegrationRuleApi.h"

@implementation UGGetIntegrationRuleApi
-(NSString *)requestUrl{
    return @"ug/appIntegration/getIntegrationRule";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
