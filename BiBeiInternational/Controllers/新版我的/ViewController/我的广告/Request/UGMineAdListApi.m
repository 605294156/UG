//
//  UGMineAdListApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMineAdListApi.h"

@implementation UGMineAdListApi

- (NSString *)requestUrl {
//    return @"/ug/otc/advertisePageList";
    return @"/ug/otcv2/advertisePageList";
}

//- (YTKRequestSerializerType)requestSerializerType {
//    return YTKRequestSerializerTypeJSON;
//}

-(NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
//    NSString *userId = [UGManager shareInstance].hostInfo.ID;
//    [dict setObject:userId.length > 0 ? userId : @""  forKey:@"memberId"];
    [dict setObject:self.currentPage forKey:@"currentPage"];
//    [dict setObject:self.marketPrice forKey:@"marketPrice"];
    return dict;
}

@end
