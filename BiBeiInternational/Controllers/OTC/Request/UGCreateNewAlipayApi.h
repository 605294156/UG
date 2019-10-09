//
//  UGCreateNewAlipayApi.h
//  BiBeiInternational
//
//  Created by keniu on 2019/9/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCreateNewAlipayApi : UGBaseRequest
//订单号
@property (nonatomic, strong) NSString *merOrderNo;
//金额
@property(nonatomic,strong)NSString *amount;
//支付类型 0:支付宝转银行卡,1:支付宝转支付宝
@property(nonatomic,strong)NSString *payType;
//银行卡号
@property (nonatomic, strong) NSString *cardNo;
//appID
@property (nonatomic, strong) NSString *appId;
//银行名称
@property (nonatomic, strong) NSString *bankName;
//银行账号名
@property (nonatomic, strong) NSString *bankAccount;
//备注
@property(nonatomic,strong)NSString *remarks;
//钱
@property(nonatomic,strong)NSString *money;
//银行编码
@property (nonatomic, strong) NSString *bankMark;

@end

NS_ASSUME_NONNULL_END
