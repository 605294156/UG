//
//  OTCInputJYPasswordVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCInputJYPasswordVC : UGBaseViewController

/**
 订单号
 */
@property (nonatomic, strong) NSString *orderSn;
    
/**
 订单详细信息模型
 */
@property(nonatomic, strong) UGOrderDetailModel *orderModel;

@end

NS_ASSUME_NONNULL_END
