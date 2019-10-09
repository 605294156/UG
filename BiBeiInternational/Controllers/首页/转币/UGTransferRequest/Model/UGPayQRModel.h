//
//  UGPayQRModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 * 二维码
 */
@interface UGPayQRModel : UGBaseModel
@property(nonatomic,copy)NSString *extra;//其他信息
@property(nonatomic,copy)NSString *loginName;//用户名
@property(nonatomic,copy)NSString *merchCardNo;//UG钱包地址
@property(nonatomic,copy)NSString *merchNo;//商户号
@property(nonatomic,copy)NSString *amount;//金额
@property(nonatomic,copy)NSString *orderSn;//订单号
@property(nonatomic,copy)NSString *orderType;//类型 0 个人  1 商户
@end

NS_ASSUME_NONNULL_END
