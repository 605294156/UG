//
//  UGBindWechatPayApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

typedef NS_ENUM(NSUInteger, UGPayType) {
    UGPayTypeWeChatPay = 0,//微信支付
    UGPayTypeAliPay,//阿里支付
    UGPayTypeUnionPay, //云闪付
};

NS_ASSUME_NONNULL_BEGIN

@interface UGBindWechatPayApi : UGBaseRequest

@property (nonatomic, assign) UGPayType payTpe;//绑定类型
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *payPassword;
@property (nonatomic, strong) NSString *qrUrl;
@property (nonatomic, strong) NSString *account;//支付宝、微信账号


@end

NS_ASSUME_NONNULL_END
