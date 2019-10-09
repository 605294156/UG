//
//  UGBankInfoModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBankInfoModel : UGBaseModel

@property (nonatomic, copy) NSString *bank;//银行名
@property (nonatomic, copy) NSString *branch;//支行名
@property (nonatomic, copy) NSString *cardNo;//卡号
@property (nonatomic, copy) NSString *bankProvince;//支行名
@property (nonatomic, copy) NSString *bankCity;//卡号

@end

NS_ASSUME_NONNULL_END
