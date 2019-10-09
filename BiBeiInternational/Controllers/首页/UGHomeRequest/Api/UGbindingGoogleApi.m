//
//  UGbindingGoogleApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGbindingGoogleApi.h"

@implementation UGbindingGoogleApi
-(NSString *)requestUrl{
    return @"ug/google/bindingGoogle";
}

-(id)requestArgument{
    self.memberId = [UGManager shareInstance].hostInfo.ID;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument setObject:!UG_CheckStrIsEmpty(self.memberId)?self.memberId:@"" forKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    return argument;
}
@end
