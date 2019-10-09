//
//  UGOrderListApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGOrderListApi.h"

@implementation UGOrderListApi

-(NSString *)requestUrl {
    return @"ug/flow/appPageListByUsername";
}

-(id)requestArgument {
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    NSString *userName = [UGManager shareInstance].hostInfo.userInfoModel.member.username;
    [argument setObject:userName ? : @"" forKey:@"username"];
    if (self.appClassType != UGAppClassType_All) {
        [argument setObject:[NSString stringWithFormat:@"%zd",self.appClassType] forKey:@"isIncome"];
    }
    [argument setObject:[self convertionToString] forKey:@"searchType"];
    
    [argument setObject:self.currentPage forKey:@"currentPage"];

    return argument;
}

-(NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (NSString *)convertionToString {
    //全部
    if ([self.searchType containsString:@"全"]) {
        return @"ALL";
    }
    //当日
    if ([self.searchType containsString:@"日"]) {
        return @"DAY";
    }
    //本周
    if ([self.searchType containsString:@"周"]) {
        return @"WEEK";
    }
    //本月
    if ([self.searchType containsString:@"月"]) {
        return @"MONTH";
    }
    
    return @"ALL";
}

@end
