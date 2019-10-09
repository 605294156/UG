//
//  UGGetTotalScoresApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetTotalScoresApi.h"

@implementation UGGetTotalScoresApi
-(NSString *)requestUrl{
    return @"ug/appIntegration/getTotalScore";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
