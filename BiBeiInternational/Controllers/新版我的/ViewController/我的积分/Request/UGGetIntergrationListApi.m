//
//  UGGetIntergrationListApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetIntergrationListApi.h"

@implementation UGGetIntergrationListApi
-(NSString *)requestUrl{
    return @"/ug/appIntegration/integrationList";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:self.currentPage forKey:@"currentPage"];
    return argument;
}
@end
