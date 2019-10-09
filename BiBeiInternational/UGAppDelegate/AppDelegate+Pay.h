//
//  AppDelegate+Pay.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/15.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Pay)

- (BOOL)ug_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)ug_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


- (BOOL)handlePayOrderWithOrderString:(NSString *)orderString;

@end

NS_ASSUME_NONNULL_END
