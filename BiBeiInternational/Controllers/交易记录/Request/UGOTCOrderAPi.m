//
//  UGOTCOrderAPi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCOrderAPi.h"

@implementation UGOTCOrderAPi

- (NSString *)requestUrl {
//    return @"/ug/otc/orderPageList";
    return @"/ug/otcv2/orderPageList";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    NSInteger index = [self convertStatusString];
    if (index != NSNotFound) {
        [dict setObject:[NSString stringWithFormat:@"%zd",index] forKey:@"status"];
    } else {
        [dict setObject:@"" forKey:@"status"];
    }
    [dict setObject:self.currentPage forKey:@"currentPage"];
    [dict setObject:@"5" forKey:@"coinId"];//默认为UG 5 可以不填
    //后台要求0即全部，不用传值key
    // 后台要求0是买入 1是支出 所以处理下
    if (self.advertiseType !=0  && self.advertiseType != NSNotFound) {
        [dict setObject:@(self.advertiseType - 1) forKey:@"advertiseType"];
    }
    return dict;
}

-(NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (NSInteger )convertStatusString {
    NSInteger index = NSNotFound;
    if ([self.status isEqualToString:@"已取消"]) {
        index = 0;
    } else if ([self.status isEqualToString:@"未付款"]) {
        index = 1;
    }else if ([self.status isEqualToString:@"已付款"]) {
        index = 2;
    }else if ([self.status isEqualToString:@"已完成"]) {
        index = 3;
    }else if ([self.status isEqualToString:@"申诉中"]) {
        index = 4;
    }
    return index;
}


@end
