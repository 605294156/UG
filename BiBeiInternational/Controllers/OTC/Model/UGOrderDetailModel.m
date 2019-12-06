//
//  UGOrderDeatilModel.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOrderDetailModel.h"

@implementation UGOrderDetailModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"commission"]) {
        if (oldValue == nil) {return @"";}
        if (property.type.typeClass  == [NSString class]) {
            NSString *value = [NSString stringWithFormat:@"%@",oldValue];
            return [value ug_amountFormat];
        }
        return oldValue;
    }
    return oldValue;
}


/**
 type 转换成 购买、出售
 0 购买 1出售
 @return 购买 or 出售
 */
- (NSString *)typeConvertToString {
    if ([self.type isEqualToString:@"0"]) {
        return @"购买";
    }
    return @"出售";
}

- (void)setDealRestitution:(NSString *)dealRestitution{
    if (dealRestitution && dealRestitution.length>0 && dealRestitution.floatValue>0) {
        _dealRestitution = dealRestitution;
    }else{
        _dealRestitution = @"0";
    }
}

- (NSString *)dealRestitutionStr{
    if (self.dealRestitution && self.dealRestitution.length>0 && self.dealRestitution.floatValue>0) {
        return self.dealRestitution;
    }else{
        return @"0";
    }
}

/**
 订单状态转换成中文
 0 已取消
 1 未付款
 2 已付款
 3 已完成
 4 申诉中
 @return 已取消 、未付款、已付款、已完成、申诉中
 */
- (NSString *)statusConvertToString {
    switch ([self.status intValue]) {
        case 0:
            return @"已取消";
            break;
        case 1:
            return @"未付款";
            break;
        case 2:
            return @"已付款";
            break;
        case 3:
            return @"已完成";
            break;
        default:
            return @"申诉中";
            break;
    }
    return @"";
}

- (NSString *)statusConvertToImageStr{
    switch ([self.status intValue]) {
        case 0:
            return @"otc_cancel";
            break;
        case 1:
            return @"otc_nopay";
            break;
        case 2:
            return @"otc_paid";
            break;
        case 3:
            return @"otc_done";
            break;
        default:
            return @"otc_appeal";
            break;
    }
    return @"";
}



/**
 卖家or买家支持的支付方式列表
 
 @return @[alipay,wechatPay,bankInfo]
 */
- (NSArray *)payModeList {
    NSMutableArray *payList = [NSMutableArray new];
    if (self.bankInfo && self.bankInfo.cardNo.length > 0) {
        [payList addObject:self.bankInfo];
    }
    if (self.alipay && self.alipay.aliNo.length > 0) {
        [payList addObject:self.alipay];
    }
    if (self.wechatPay && self.wechatPay.wechat.length > 0) {
        [payList addObject:self.wechatPay];
    }
    if (self.unionPay && self.unionPay.unionNo.length > 0) {
        [payList addObject:self.unionPay];
    }
    return payList;
}


@end
