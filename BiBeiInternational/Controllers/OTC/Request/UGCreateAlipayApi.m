//
//  UGCreateAlipayApi.m
//  BiBeiInternational
//
//  Created by keniu on 2019/7/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCreateAlipayApi.h"

@implementation UGCreateAlipayApi

- (NSString *)requestUrl {
    return @"ug/alipay/createAlipay";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

//- (YTKRequestSerializerType)requestSerializerType {
//    return YTKRequestSerializerTypeHTTP;
//}
//
//- (YTKResponseSerializerType)responseSerializerType {
//    return YTKResponseSerializerTypeHTTP;
//}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    if (!UG_CheckStrIsEmpty(self.appId)) {
        [dict setObject:self.appId forKey:@"appId"];
    }
    if (!UG_CheckStrIsEmpty(self.cardNo)) {
        [dict setObject:self.cardNo forKey:@"cardNo"];
    }
    if (!UG_CheckStrIsEmpty(self.bankAccount)) {
        [dict setObject:self.bankAccount forKey:@"bankAccount"];
    }
    if (!UG_CheckStrIsEmpty(self.bankMark)) {
        [dict setObject:self.bankMark forKey:@"bankMark"];
    }
    if (!UG_CheckStrIsEmpty(self.bankName)) {
        [dict setObject:self.bankName forKey:@"bankName"];
    }
    if (!UG_CheckStrIsEmpty(self.money)) {
        [dict setObject:self.money forKey:@"money"];
    }
    if (!UG_CheckStrIsEmpty(self.amount)) {
        [dict setObject:self.amount forKey:@"amount"];
    }
    return dict;
}

@end
