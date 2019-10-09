//
//  UGGenerateGoogleKeyApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGGenerateGoogleKeyApi.h"

@implementation UGGenerateGoogleKeyApi
-(NSString *)requestUrl{
    return @"ug/google/generateGoogleKey";
}

-(id)requestArgument{
    self.memberId = [UGManager shareInstance].hostInfo.ID;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument setObject:!UG_CheckStrIsEmpty(self.memberId)?self.memberId:@"" forKey:@"id"];
    return argument;
}
@end
