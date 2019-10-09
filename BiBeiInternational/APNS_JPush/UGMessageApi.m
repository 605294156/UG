//
//  UGMessageApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMessageApi.h"

@implementation UGMessageApi
-(NSString *)requestUrl{
    return @"ug/message/pageListByMessageType";
}

-(id)requestArgument{
    self.receiver = [UGManager shareInstance].hostInfo.username;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.receiver)?self.receiver:@" " forKey:@"receiver"];
    return argument;
}
@end
