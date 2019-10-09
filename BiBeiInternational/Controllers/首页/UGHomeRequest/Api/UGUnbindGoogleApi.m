//
//  UGUnbindGoogleApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGUnbindGoogleApi.h"

@implementation UGUnbindGoogleApi
-(NSString *)requestUrl{
    return @"ug/google/reGenerateGoogleKey";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument setObject:!UG_CheckStrIsEmpty(self.key)?self.key:@"" forKey:@"key"];
    return argument;
}
@end
