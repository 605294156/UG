//
//  UGLinkmanApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGLinkmanApi.h"

@implementation UGLinkmanApi

- (NSString *)requestUrl {
    return @"ug/chat/relationList";
}

- (id)requestArgument{
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    return dict;
}

@end
