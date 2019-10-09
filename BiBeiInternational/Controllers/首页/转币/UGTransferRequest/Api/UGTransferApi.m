//
//  UGTransferApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGTransferApi.h"

@implementation UGTransferApi

-(NSString *)requestUrl{
    return @"ug/app/pay";
}

- (NSTimeInterval)requestTimeoutInterval{
    return 60;
}

-(id)requestArgument{

    self.sloginName = [UGManager shareInstance].hostInfo.username;
    NSMutableDictionary *argument  = [super requestArgument];//如果有父类 确定参数 如 设备号 就先拿到父类的
    [argument setObject:!UG_CheckStrIsEmpty(self.version)?self.version:@"" forKey:@"version"];
    [argument setObject:!UG_CheckStrIsEmpty(self.googleCode)?self.googleCode:@"" forKey:@"googleCode"];
    [argument setObject:!UG_CheckStrIsEmpty(self.sloginName)?self.sloginName:@"" forKey:@"sloginName"];
    [argument setObject:!UG_CheckStrIsEmpty(self.payPassword)?self.payPassword:@"" forKey:@"payPassword"];
    [argument setObject:!UG_CheckStrIsEmpty(self.spayCardNo)?self.spayCardNo:@"" forKey:@"spayCardNo"];
    [argument setObject:!UG_CheckStrIsEmpty(self.aloginName)?self.aloginName:@"" forKey:@"aloginName"];
    [argument setObject:!UG_CheckStrIsEmpty(self.apayCardNo)?self.apayCardNo:@"" forKey:@"apayCardNo"];
    [argument setObject:!UG_CheckStrIsEmpty(self.tradeAmount)?self.tradeAmount:@"" forKey:@"tradeAmount"];
    [argument setObject:!UG_CheckStrIsEmpty(self.tradeUgNumber)?self.tradeUgNumber:@"" forKey:@"tradeUgNumber"];
    [argument setObject:!UG_CheckStrIsEmpty(self.orderType)?self.orderType:@"" forKey:@"orderType"];
    [argument setObject:!UG_CheckStrIsEmpty(self.remark)?self.remark:@"" forKey:@"remark"];
    if ([self.orderType isEqualToString:@"1"]) {
        [argument setObject:!UG_CheckStrIsEmpty(self.merchNo)?self.merchNo:@"" forKey:@"merchNo"];
        [argument setObject:!UG_CheckStrIsEmpty(self.goodsName)?self.goodsName:@"" forKey:@"goodsName"];
        [argument setObject:!UG_CheckStrIsEmpty(self.orderSn)?self.orderSn:@"" forKey:@"orderSn"];
    }
    //暂时不定  需确定 参数结构
    return argument;
}

@end
