//
//  UGOTCPayDetailModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGAlipayModel.h"
#import "UGWechatPayModel.h"
#import "UGBankInfoModel.h"
#import "UGUnionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCPayDetailModel : UGBaseModel

@property (nonatomic, strong) UGAlipayModel * alipay;
@property (nonatomic, strong) UGWechatPayModel * wechatPay;
@property (nonatomic, strong) UGBankInfoModel * bankInfo;
@property (nonatomic, strong) UGUnionModel * unionPay;

@end

NS_ASSUME_NONNULL_END
