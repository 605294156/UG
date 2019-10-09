//
//  UGFavorFindApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/2/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGFavorFindApi.h"

@implementation UGFavorFindApi
-(NSString *)requestUrl{
    return @"market/favor/find";
}

-(id)requestArgument{
    self.memberId = [UGManager shareInstance].hostInfo.ID;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.memberId)?self.memberId:@"" forKey:@"memberId"];
    return argument;
}
@end
