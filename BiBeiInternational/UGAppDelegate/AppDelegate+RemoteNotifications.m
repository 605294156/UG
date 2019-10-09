//
//  AppDelegate+Notifications.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+RemoteNotifications.h"
#import "AppDelegate+Socket.h"
#import "ChatGroupInfoModel.h"
#import "ChatGroupFMDBTool.h"
#import "ZLGestureLockViewController.h"

#import <objc/runtime.h>


static NSString *deviceTokenKey = @"deviceTokenKey";


@implementation AppDelegate (RemoteNotifications)


- (void)ug_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //远程通知
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                   settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                   categories:nil]];
    [[UIApplication sharedApplication]registerForRemoteNotifications];

}


#pragma mark-注册远程通知
-(void)ug_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //弹出手势解锁
    [self showGestureLockViewController];
    //获取deviceToken
   self.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //Socket注册远程推送
    [self sendSocketMesssageWithDeviceToken:self.deviceToken];
    
    NSLog(@"注册远程推送成功——————%@",self.deviceToken);
}

#pragma mark-注册远程通知失败
- (void)ug_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"远程推送注册失败--%@",[error description]);
}

#pragma mark-收到远程推送(点击通知栏进入App或者App在前台时触发)
- (void)ug_application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){//点击通知栏进来
        
    }
}

#pragma mark-弹出手势密码解锁
-(void)showGestureLockViewController {
    if([[UGManager shareInstance] hasLogged]&&[ZLGestureLockViewController gesturesPassword].length > 0){
        [EasyShowLodingView hidenLoding];
        ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeValidatePsw];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}


#pragma mark - Setter Getter Method

- (void)setDeviceToken:(NSString *)deviceToken {
    objc_setAssociatedObject(self, &deviceTokenKey, deviceToken, OBJC_ASSOCIATION_COPY_NONATOMIC);

}


- (NSString *)deviceToken {
    return objc_getAssociatedObject(self, &deviceTokenKey);
}


@end
