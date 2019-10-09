//
//  UGNotifyUpdateStatusApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGNotifyUpdateStatusApi.h"

@implementation UGNotifyUpdateStatusApi
-(NSString *)requestUrl{
    return @"ug/message/updateBatchRead";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.ids)?self.ids:@" " forKey:@"ids"];
    return argument;
}
@end
