//
//  UGCheckUserAuxiliariesApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCheckUserAuxiliariesApi.h"

@implementation UGCheckUserAuxiliariesApi
-(NSString *)requestUrl{
    return @"ug/member/checkUserAuxiliaries";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.userAuxiliaries)?self.userAuxiliaries:@"" forKey:@"userAuxiliaries"];
    [argument setObject:!UG_CheckStrIsEmpty(self.username)?self.username:@"" forKey:@"username"];
    return argument;
}

@end
