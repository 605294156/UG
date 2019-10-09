//
//  UIView+MBHUD.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MBHUD)

/**
 MBProgressHud显示在self上
 */
- (void)ug_showMBProgressHUD;


/**
 取消在self上显示的MBProgressHud
 */
- (void)ug_hiddenMBProgressHUD;



/**
 MBProgressHud显示在KeyWindow上
 */
- (void)ug_showMBProgressHudOnKeyWindow;


/**
 取消在KeyWindow上显示的MBProgressHud
 */
- (void)ug_hiddenMBProgressHudOnKeyWindow;


@end

NS_ASSUME_NONNULL_END
