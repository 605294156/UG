//
//  UGNotifyListApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGNotifyListApi.h"

@implementation UGNotifyListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = 1;
    }
    return self;
}

-(NSString *)requestUrl{
    return @"ug/message/pageListByExample";
}

-(NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

-(id)requestArgument{
    self.receiver = [UGManager shareInstance].hostInfo.username;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:@(self.currentPage) forKey:@"currentPage"];
    [argument setObject:!UG_CheckStrIsEmpty(self.receiver)?self.receiver:@" " forKey:@"receiver"];
    [argument setObject:!UG_CheckStrIsEmpty(self.status)?self.status:@" " forKey:@"status"];
    [argument setObject:!UG_CheckStrIsEmpty(self.parentMessageType)?self.parentMessageType:@" " forKey:@"parentMessageType"];
    return argument;
}
@end
