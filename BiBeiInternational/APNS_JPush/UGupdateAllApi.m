//
//  UGupdateAllApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGupdateAllApi.h"

@implementation UGupdateAllApi
-(NSString *)requestUrl{
    return @"ug/message/updateAll";
}

-(id)requestArgument{
    self.receiver = [UGManager shareInstance].hostInfo.username;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.receiver)?self.receiver:@" " forKey:@"receiver"];
    [argument setObject:!UG_CheckStrIsEmpty(self.parentMessageType)?self.parentMessageType:@" " forKey:@"parentMessageType"];
    return argument;
}
@end
