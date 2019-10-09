//
//  UIView+MBHUD.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UIView+MBHUD.h"

@implementation UIView (MBHUD)

- (void)ug_showMBProgressHUD {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

- (void)ug_hiddenMBProgressHUD {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)ug_showMBProgressHudOnKeyWindow {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)ug_hiddenMBProgressHudOnKeyWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

@end
