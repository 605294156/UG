//
//  UGGetOpeningOrderStatusaApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetOpeningOrderStatusaApi.h"

@implementation UGGetOpeningOrderStatusaApi
-(NSString *)requestUrl{
    return @"ug/appIntegration/getOpeningOrderStatus";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
