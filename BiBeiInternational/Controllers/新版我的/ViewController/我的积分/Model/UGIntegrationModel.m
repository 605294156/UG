//
//  UGIntegrationModel.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGIntegrationModel.h"

@implementation UGIntegrationModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

-(NSString *)returnStatus{
    if ([self.type isEqualToString:@"1"]) {
        return @"订单超时取消";
    }else  if ([self.type isEqualToString:@"2"]) {
        return @"取消订单";
    }else  if ([self.type isEqualToString:@"3"]) {
        return @"完成平台派单";
    }else  if ([self.type isEqualToString:@"4"] || [self.type isEqualToString:@"5"]) {
        return @"平台充值";
    }else  if ([self.type isEqualToString:@"6"]) {
         return @"连续接单奖励";
    }else  if ([self.type isEqualToString:@"7"] || [self.type isEqualToString:@"8"]) {
        return @"连续关闭接单";
    }
    return @"";
}
@end
