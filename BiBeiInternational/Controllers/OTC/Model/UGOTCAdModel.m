//
//  UGOTCAdModel.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCAdModel.h"

@implementation UGOTCAdModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"remainAmount"] || [property.name isEqualToString:@"price"] || [property.name isEqualToString:@"number"] ) {
        if (oldValue == nil) {return @"";}
        if (property.type.typeClass  == [NSString class]) {
            NSString *value = [NSString stringWithFormat:@"%@",oldValue];
            return [value ug_amountFormat];
        }
        return oldValue;
    }
    return oldValue;
}


- (NSString *)advertiseTypeConvertToString {
    if ([self.advertiseType isEqualToString:@"0"]) {
        return @"出售";
    }
    return @"购买";
}


/**
 卖家和买家的支付方式是否有一种匹配
 
 */
- (BOOL)checkPayModeMatch {
    UGUserInfoModel *infoModel = [UGManager shareInstance].hostInfo.userInfoModel;
    NSArray* array = [self.payMode componentsSeparatedByString:@","];
    BOOL match = NO;
    if ( ! UG_CheckArrayIsEmpty(array) && array.count >0) {
        for (NSString *obj in array) {
            if (infoModel.hasWechatPay  && [obj containsString:@"微信"]) {
                match = YES;
            } else if (infoModel.hasAliPay && [obj containsString:@"支付宝"]) {
                match = YES;
            } else if (infoModel.hasBankBinding && [obj containsString:@"银行卡"]) {
                match = YES;
            }else if (infoModel.hasUnionPay && [obj containsString:@"云闪付"]) {
                match = YES;
            }
        }
    }
    return match;
}

/**
 返回买家的支付方式
 */
-(NSString *)machPayModelStr{
    NSMutableArray *arr = [NSMutableArray new];
    NSArray* array = [self.payMode componentsSeparatedByString:@","];
    if ( ! UG_CheckArrayIsEmpty(array) && array.count >0) {
        for (NSString *obj in array) {
            if ([obj containsString:@"银行卡"]) {
                [arr addObject:@"银行卡"];
            }else if ( [obj containsString:@"支付宝"]) {
                [arr addObject:@"支付宝"];
            }else if ([obj containsString:@"微信"]) {
                [arr addObject:@"微信"];
            }else if ([obj containsString:@"云闪付"]) {
                [arr addObject:@"云闪付"];
            }
        }
    }
    return [arr componentsJoinedByString:@","];
}


@end
