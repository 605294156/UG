//
//  UGAdvertisingPayModeVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAdvertisingPayModeVC : UGTableViewController

@property (nonatomic, copy) void (^choosePayModHandle)(NSArray <NSString *>*payMode);

@end

NS_ASSUME_NONNULL_END
