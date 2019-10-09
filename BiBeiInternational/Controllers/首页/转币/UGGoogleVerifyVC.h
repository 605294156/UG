//
//  UGGoogleVerifyVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface UGGoogleVerifyVC : UGBaseViewController

@property (nonatomic, copy) NSString *aloginName;//接收用户登录名
@property (nonatomic, copy) NSString *apayCardNo;//接收UG钱包地址
@property (nonatomic, copy) NSString *tradeAmount;//交易金额,单位UG
@property (nonatomic, copy) NSString *tradeUgNumber;//交易数量, ==交易金额
@property (nonatomic, copy) NSString *passWords;//支付密码, ==交易金额
@property (nonatomic, copy) NSString *remark;//备注
@property(nonatomic,copy)NSString *orderType;//类型
@property(nonatomic,copy)NSString *merchNo;//商户号
@property(nonatomic,copy)NSString *orderSn;//订单号
@property(nonatomic,copy)NSString *extra;//其他信息

@end
