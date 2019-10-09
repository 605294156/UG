//
//  UGOTCExchageModel.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCExchageModel.h"

/*状态 0交易中 1完成 2取消 3超时*/
@implementation UGOTCExchageModel
- (NSString *)stautsConvertToString {
    NSString *string = @"";
    if ([self.status isEqualToString:@"0"]) {
        string = @"交易中";
    } else if (([self.status isEqualToString:@"1"])) {
        string = @"已完成";
    } else if (([self.status isEqualToString:@"2"])) {
        string = @"已取消";
    } else if (([self.status isEqualToString:@"3"])) {
        string = @"已超时";
    }
    return string;
}
@end
