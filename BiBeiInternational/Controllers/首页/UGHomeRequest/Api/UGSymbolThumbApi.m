//
//  UGSymbolThumbApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/2/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSymbolThumbApi.h"

@implementation UGSymbolThumbApi
-(NSString *)requestUrl{
    return @"market/symbolThumbV2";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end
