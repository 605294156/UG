//
//  UGSubmitUserAuxiliariesApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSubmitUserAuxiliariesApi.h"

@implementation UGSubmitUserAuxiliariesApi
-(NSString *)requestUrl{
    return @"ug/member/submitUserAuxiliaries";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.userAuxiliaries)?self.userAuxiliaries:@"" forKey:@"userAuxiliaries"];
    return argument;
}
@end
