//
//  UGExchangeApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGExchangeApi.h"

@implementation UGExchangeApi

- (NSString *)requestUrl {
    return @"/ug/exchange/orderPageByExample";
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
    //后台要求0即全部，不用传值key
    // 后台要求0是买入 1是支出 所以处理下
    if (self.direction !=0  && self.direction != NSNotFound) {
        [dict setObject:@(self.direction -1) forKey:@"direction"];
    }

    return dict;
}

- (NSInteger )convertStatusString {
    NSInteger index = NSNotFound;
    if ([self.status isEqualToString:@"交易中"]) {
        index = 0;
    } else if ([self.status isEqualToString:@"已完成"]) {
        index = 1;
    }else if ([self.status isEqualToString:@"已取消"]) {
        index = 2;
    }else if ([self.status isEqualToString:@"已超时"]) {
        index = 3;
    }
    return index;
}


@end
