//
//  UIDevice+UGExpand.m
//  ug-wallet
//
//  Created by keniu on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UIDevice+UGExpand.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/utsname.h>
#import <stdio.h>
#import <stdlib.h>

@implementation UIDevice (UGExpand)


/**
 判断当前设备是否是X系列
 目前包括iPhone X、iPhone XS、iPhone XS Max、iPhone XR
 此方法需要发布新机后更新,不适合模拟器！
 */
+ (BOOL)isIphoneXSeries {
    
//    struct utsname systemInfo;
//
//    uname(&systemInfo);
//
//    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
//
//    NSLog(@"获取到当前设备的名字: %@", platform);
//
//    if ([platform isEqualToString:@"iPhone10,3"]) return YES;//iPhone X
//    if ([platform isEqualToString:@"iPhone10,6"]) return YES;//iPhone X
//
//
//    if ([platform isEqualToString:@"iPhone11,8"]) return YES;//iPhone XR
//
//    if ([platform isEqualToString:@"iPhone11,2"]) return YES;//iPhone XS
//
//
//    if ([platform isEqualToString:@"iPhone11,4"]) return YES;//iPhone XS Max
//    if ([platform isEqualToString:@"iPhone11,6"]) return YES;//iPhone XS Max
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    //通过底部的safeAreaInsets来判断
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}

@end
