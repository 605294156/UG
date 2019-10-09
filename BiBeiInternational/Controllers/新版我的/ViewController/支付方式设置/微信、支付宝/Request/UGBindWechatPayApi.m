//
//  UGBindWechatPayApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBindWechatPayApi.h"

@implementation UGBindWechatPayApi

- (NSString *)requestUrl {
    return @"ug/otcv2/bindingPayInfo";
}



- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    NSString *type =  self.payTpe == UGPayTypeUnionPay ? @"union" : (self.payTpe == UGPayTypeAliPay ? @"aliNo" : @"wechat");
    NSString *meberId = [UGManager shareInstance].hostInfo.userInfoModel.member.ID;
    [dict setObject:meberId forKey:@"memberId"];
    [dict setObject:self.account forKey:type];
    [dict setObject:self.payPassword forKey:@"payPassword"];
    [dict setObject:self.realName forKey:@"realName"];
    NSString *typeUrl = self.payTpe == UGPayTypeUnionPay ? @"qrUnionCodeUrl" : (self.payTpe == UGPayTypeAliPay ? @"qrCodeUrl" : @"qrWeCodeUrl");
    [dict setObject:self.qrUrl forKey:typeUrl];
    return dict;
}

@end
