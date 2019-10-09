//
//  UGReBindingApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReBindingApi.h"

@implementation UGReBindingApi
-(NSString *)requestUrl{
    return @"ug/google/reBindingGoogle";
}

-(id)requestArgument{
    self.memberId = [UGManager shareInstance].hostInfo.ID;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.memberId)?self.memberId:@"" forKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    return argument;
}
@end
