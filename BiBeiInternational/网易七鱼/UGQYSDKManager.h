//
//  UGQYSDKManager.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UGQYSDKManager : NSObject
+ (instancetype) shareInstance;

/**
拿到网易七鱼推送数据做处理
 */
- (void)showChatViewController:(NSDictionary *)remoteNotificationInfo;
/**
 个人信息CRM 上报
 */
-(void)updateDateQYUserInfo:(NSString *)sno isLogin:(BOOL)login;
/**
 注销QYSDK
 此方法只在- 用户退出登录或者账号失效的时 执行
 */
- (void)logoutQYSDK;

@end

NS_ASSUME_NONNULL_END
