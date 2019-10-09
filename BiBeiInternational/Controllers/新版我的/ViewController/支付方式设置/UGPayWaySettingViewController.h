//
//  UGPayWaySettingViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayWaySettingViewController : UGTableViewController

/**
 已经选择的支付方式
 */
@property (nonatomic, strong) NSArray *payWays;
@property (nonatomic, assign) BOOL isReleaseAd;//发布交易
@property (nonatomic, strong) UIViewController *topVC ;//出售列表进来回到出售列页面
@property (nonatomic, copy) void (^choosePayModHandle)(NSArray <NSString *>*payMode);
@property (nonatomic,copy) NSString  *sellOrBuy; // "0"  购买  "1"   出售
@end

NS_ASSUME_NONNULL_END
