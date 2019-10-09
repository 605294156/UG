//
//  UGBindBankPayApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBindBankPayApi.h"

@implementation UGBindBankPayApi

- (NSString *)requestUrl {
    return  @"ug/otcv2/bindingPayInfo";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    NSString *meberId = [UGManager shareInstance].hostInfo.userInfoModel.member.ID;
    [dict setObject:meberId forKey:@"memberId"];
    [dict setObject: !UG_CheckStrIsEmpty(self.bank) ? self.bank : @"" forKey:@"bank"];
    [dict setObject: !UG_CheckStrIsEmpty(self.realName) ? self.realName : @"" forKey:@"realName"];
    [dict setObject: !UG_CheckStrIsEmpty(self.payPassword) ? self.payPassword : @"" forKey:@"payPassword"];
    [dict setObject: !UG_CheckStrIsEmpty(self.cardNo) ? self.cardNo : @"" forKey:@"cardNo"];
    [dict setObject: !UG_CheckStrIsEmpty(self.bankProvince) ? self.bankProvince : @"" forKey:@"bankProvince"];
    [dict setObject: !UG_CheckStrIsEmpty(self.bankCity) ? self.bankCity : @"" forKey:@"bankCity"];

    return dict;
}

@end
