//
//  UGCreateAlipayApi.h
//  BiBeiInternational
//
//  Created by keniu on 2019/7/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCreateAlipayApi : UGBaseRequest
@property (nonatomic, strong) NSString *appId;
//银行卡号
@property (nonatomic, strong) NSString *cardNo;
//银行账号名
@property (nonatomic, strong) NSString *bankAccount;
//银行编码
@property (nonatomic, strong) NSString *bankMark;
//银行名
@property (nonatomic, strong) NSString *bankName;
//钱
@property(nonatomic,strong)NSString *money;
//数量
@property(nonatomic,strong)NSString *amount;
@end

NS_ASSUME_NONNULL_END
