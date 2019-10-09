//
//  MBProgressHUD+Expand.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Expand)

+ (MBProgressHUD *)ug_showHUDToKeyWindow;

+ (void)ug_hideHUDFromKeyWindow;


+ (MBProgressHUD *)ug_showHUDToView:(UIView *)view;

+ (void )ug_hideHUDForView:(UIView *)view;

+ (MBProgressHUD *)ug_showMessage:(NSString *)message toView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
