//
//  MBProgressHUD+Expand.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "MBProgressHUD+Expand.h"

@implementation MBProgressHUD (Expand)

+ (MBProgressHUD* )ug_showHUDToKeyWindow {
    return [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}


+ (void )ug_hideHUDFromKeyWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (MBProgressHUD *)ug_showHUDToView:(UIView *)view {
    return [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void )ug_hideHUDForView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];

}

+ (MBProgressHUD *)ug_showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

@end
