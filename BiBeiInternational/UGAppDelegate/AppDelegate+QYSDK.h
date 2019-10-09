//
//  AppDelegate+QYSDK.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (QYSDK)<UNUserNotificationCenterDelegate>

- (void)ug_initQYSDKDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)ug_QYSDKRegisterDeviceToken:(NSData *)deviceToken;

- (void)ug_QYSDKDidReceiveRemoteNotification:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
