//
//  AppDelegate+Socket.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Socket)

/**
 连接socket
 */
- (void)connectSocket;


/**
 发送消息
 */
- (void)sendSocketMesssageWithDeviceToken:(NSString *)deviceToken;

@end

NS_ASSUME_NONNULL_END
