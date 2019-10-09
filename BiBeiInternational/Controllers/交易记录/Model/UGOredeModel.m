//
//  UGOredeModel.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOredeModel.h"

@implementation UGOredeModel


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"money"] || [property.name isEqualToString:@"price"] || [property.name isEqualToString:@"number"] ) {
        if (oldValue == nil) {return @"";}
        if (property.type.typeClass  == [NSString class]) {
            NSString *value = [NSString stringWithFormat:@"%@",oldValue];
            return [value ug_amountFormat];
        }
        return oldValue;
    }
    return oldValue;
}


- (NSString *)stautsConvertToString {
    NSString *string = @"";
    if ([self.status isEqualToString:@"0"]) {
        string = @"已取消";
    } else if (([self.status isEqualToString:@"1"])) {
        string = @"未付款";
    } else if (([self.status isEqualToString:@"2"])) {
        string = @"已付款";
    } else if (([self.status isEqualToString:@"3"])) {
        string = @"已完成";
    } else if (([self.status isEqualToString:@"4"])) {
        string = @"申诉中";
    }
    return string;
}

- (NSString *)stautsConvertToImageStr{
    NSString *string = @"";
    if ([self.status isEqualToString:@"0"]) {
        string = @"account_cancel";
    } else if (([self.status isEqualToString:@"1"])) {
        string = @"account_nopay";
    } else if (([self.status isEqualToString:@"2"])) {
        string = @"account_paid";
    } else if (([self.status isEqualToString:@"3"])) {
        string = @"account_done";
    } else if (([self.status isEqualToString:@"4"])) {
        string = @"account_appeal";
    }
    return string;
}


/**
 订单类型转换成买入卖出
 
 @return 买入、卖出
 */
- (NSString *)orderTypeConvertToString {
    if ([self.orderType isEqualToString:@"0"]) {
        return @"购买";
    }
    return @"出售";

}

@end
