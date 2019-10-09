//
//  UGGetPlayUrlApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetPlayUrlApi.h"

@implementation UGGetPlayUrlApi
-(NSString *)requestUrl{
    return @"ug/dictionary/findValue";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:@"videoUrl" forKey:@"dicKey"];
    return argument;
}
@end
