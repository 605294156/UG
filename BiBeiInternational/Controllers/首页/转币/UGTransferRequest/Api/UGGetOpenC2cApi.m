//
//  UGGetOpenC2cApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetOpenC2cApi.h"

@implementation UGGetOpenC2cApi
-(NSString *)requestUrl{
    return @"ug/member/getOpenC2c";
}

-(id)requestArgument{
    
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    
    return argument;
}
@end
