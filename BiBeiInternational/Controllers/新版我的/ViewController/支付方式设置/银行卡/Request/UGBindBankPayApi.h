//
//  UGBindBankPayApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBindBankPayApi : UGBaseRequest

@property(nonatomic, strong) NSString *bank;//银行名
@property(nonatomic, strong) NSString *payPassword;//钱包支付密码
@property(nonatomic, strong) NSString *realName;//真实姓名
@property(nonatomic, strong) NSString *cardNo;//银行卡号
@property(nonatomic, strong) NSString *bankProvince;//银行区域-省
@property(nonatomic, strong) NSString *bankCity;//银行区域-市

@end

NS_ASSUME_NONNULL_END
