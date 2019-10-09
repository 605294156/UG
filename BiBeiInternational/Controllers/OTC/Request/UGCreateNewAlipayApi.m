//
//  UGCreateNewAlipayApi.m
//  BiBeiInternational
//
//  Created by keniu on 2019/9/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCreateNewAlipayApi.h"

@implementation UGCreateNewAlipayApi
- (NSString *)requestUrl {
    return @"ug/otc/alipay/order/createCmAlipay";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

///  Response serializer type. See also `responseObject`.
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}


/**
 *普通请求  10s
 *上传图片请求 30s
 *涉及资金请求 60s
 *列表类请求 60s
 **/
- (NSTimeInterval)requestTimeoutInterval {
    return 10.0;
}

-(NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    //登录后，后台返回。直接丢回给后台.
    NSString *access_auth_token = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
    [request setValue:access_auth_token ? access_auth_token : @"" forKey:@"access-auth-token"];
    //安全加密
    [request setValue:[UG_MethodsTool accessAuthUgcoinEncryption] forKey:@"access-auth-ugcoin"];
    //请求返回国际化
    NSString *language= LocalizationKey(@"responseLanguage");
    [request setValue:language forKey:@"Accept-Language"];
    [request setValue:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    return request;
}


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
    if (!UG_CheckStrIsEmpty(self.merOrderNo)) {
        [dict setObject:self.merOrderNo forKey:@"merOrderNo"];
    }
    if (!UG_CheckStrIsEmpty(self.bankName)) {
        [dict setObject:self.bankName forKey:@"bankName"];
    }
    
    if (!UG_CheckStrIsEmpty(self.payType)) {
        [dict setObject:self.payType forKey:@"payType"];
    }
    
    if (!UG_CheckStrIsEmpty(self.amount)) {
        [dict setObject:self.amount forKey:@"amount"];
    }
    
    if (!UG_CheckStrIsEmpty(self.remarks)) {
        [dict setObject:self.remarks forKey:@"remarks"];
    }
    
    if (!UG_CheckStrIsEmpty(self.money)) {
        [dict setObject:self.money forKey:@"money"];
    }
    
    if (!UG_CheckStrIsEmpty(self.bankMark)) {
        [dict setObject:self.bankMark forKey:@"bankMark"];
    }
    
    return dict;
}


@end
