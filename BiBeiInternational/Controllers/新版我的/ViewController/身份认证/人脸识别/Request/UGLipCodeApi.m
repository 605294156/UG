//
//  UGLipCodeApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGLipCodeApi.h"

@implementation UGLipCodeApi
- (NSString *)requestUrl {
    return @"ug/application/lipCode";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];;
    return dict;
}
@end
