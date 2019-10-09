//
//  AppDelegate+Guaid.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+Guaid.h"
#import "KSGuaidViewManager.h"

@implementation AppDelegate (Guaid)

- (void)showGuaid {
//    KSGuaidManager.images = @[[UIImage imageNamed:@"guid01"],
//                              [UIImage imageNamed:@"guid02"],
//                              [UIImage imageNamed:@"guid03"]];
    KSGuaidManager.images = @[];
    KSGuaidManager.shouldDismissWhenDragging = YES;
    KSGuaidManager.pageIndicatorTintColor=[UIColor whiteColor];
    KSGuaidManager.currentPageIndicatorTintColor=baseColor;
    [KSGuaidManager begin];
}

@end
