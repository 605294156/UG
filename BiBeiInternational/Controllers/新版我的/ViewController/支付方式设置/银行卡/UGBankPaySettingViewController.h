//
//  UGBankPaySettingViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBankPaySettingViewController : UGBaseViewController

@property (nonatomic, assign) BOOL updateBind;

@property(nonatomic, copy) void(^handle)(void);

@property (nonatomic, strong) UIViewController *topVC;

@end

NS_ASSUME_NONNULL_END
