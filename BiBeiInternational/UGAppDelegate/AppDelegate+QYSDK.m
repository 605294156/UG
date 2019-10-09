//
//  AppDelegate+QYSDK.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+QYSDK.h"
#import "UGQYSDKManager.h"
#import "QYSDK.h"
#import "UGQYSDKManager.h"

@implementation AppDelegate (QYSDK)
- (void)ug_initQYSDKDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self initQYSDKWithFinishLaunchingWithOptions:launchOptions];
}

#pragma -mark 初始化QYSDK
- (void)initQYSDKWithFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Required - 启动 QYSDK SDK
    NSString *keys =  [[UG_MethodsTool getBundleID] isEqualToString : BUNDLEID] ? QYSDKAPPKEY : QYSDKAPPKEY_TEST;
    NSString *savekey = [NSUserDefaultUtil GetDefaults: @"qykey"];
    if (UG_CheckStrIsEmpty(savekey)) {
        [NSUserDefaultUtil PutDefaults:@"qykey" Value: keys];
        savekey = keys;
    }
    [[QYSDK sharedSDK] registerAppId: savekey appName:QYSDKNAME];

    
//    if (@available(iOS 10.0, *)) {
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        }];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else if (@available(iOS 8.0, *)) {
//        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
//    }
    
    NSDictionary *remoteNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationInfo) {
        [self ug_QYSDKDidReceiveRemoteNotification:remoteNotificationInfo];
    }
}


- (void)ug_QYSDKRegisterDeviceToken:(NSData *)deviceToken{
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)ug_QYSDKDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [[UGQYSDKManager shareInstance] showChatViewController:userInfo];
   // }
}
@end
