//
//  UGMineAdViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMineAdViewController : UGTableViewController


/**
 是否支持侧滑返回，默认打开
 发布交易成功后跳转到此不支持侧滑返回
 */
@property(nonatomic ,assign) BOOL popGestureRecognizerEnabled;//默认打开

@property(nonatomic,copy)NSString *isBuyOrSell;//0 购买  1 出售

@end

NS_ASSUME_NONNULL_END
