//
//  UIView+UGToast.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UIView+UGToast.h"
#import "UIView+Toast.h"

@implementation UIView (UGToast)


- (void)ug_showToastWithToast:(NSString *)toast {
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    toastStyle.cornerRadius = 6.0f;
    toastStyle.backgroundColor = [UIColor colorWithHexString:@"000000" andAlpha:0.85f];
    toastStyle.messageFont = UGSystemFont(15);
    toastStyle.horizontalPadding = 13;
    toastStyle.verticalPadding = 13;
    toastStyle.messageAlignment = NSTextAlignmentCenter;
    toastStyle.maxWidthPercentage = (kWindowW - 200 )/320.0;
    [self makeToast:toast duration:1.5f position:CSToastPositionCenter style:toastStyle];
}


- (void)ug_showSpeialToastWithToast:(NSString *)toast {
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    toastStyle.cornerRadius = 6.0f;
    toastStyle.backgroundColor = [UIColor colorWithHexString:@"000000" andAlpha:0.85f];
    toastStyle.messageFont = UGSystemFont(15);
    toastStyle.horizontalPadding = 13;
    toastStyle.verticalPadding = 30;
    toastStyle.messageAlignment = NSTextAlignmentCenter;
    toastStyle.maxWidthPercentage =  kWindowW == 320 ? (200.0 / 320) : (kWindowW - 200 )/320.0;
    [self makeToast:toast duration:1.0f position:CSToastPositionCenter style:toastStyle];
}

@end
