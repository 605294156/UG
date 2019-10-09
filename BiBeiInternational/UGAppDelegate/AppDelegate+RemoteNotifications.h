//
//  AppDelegate+Notifications.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate.h"
#import "UGTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (RemoteNotifications)

/**
 远程推送Token
 */
@property(nonatomic,copy) NSString *deviceToken;

- (void)ug_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


-(void)ug_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;


- (void)ug_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


- (void)ug_application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler;

/**
 手势解锁页面
 内部已处理是否设置了手势解锁
 已设置才会跳转
 */
-(void)showGestureLockViewController;

@end

NS_ASSUME_NONNULL_END
