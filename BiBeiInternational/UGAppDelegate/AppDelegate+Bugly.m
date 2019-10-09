//
//  AppDelegate+Bugly.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/11.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+Bugly.h"
#import <Bugly/Bugly.h>

@implementation AppDelegate (Bugly)

-(void)start_Bugly{
    // 启动Bugly
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.deviceIdentifier = [UIDevice currentDevice].identifierForVendor.UUIDString; //设备标识
#if DEBUG
    config.debugMode = YES; //SDK Debug信息开关, 默认关闭
    config.channel = @"debug";
#else
    config.channel = @"release";
#endif
    
    NSString *keys =  [[UG_MethodsTool getBundleID] isEqualToString:BUNDLEID] ? BUGLY_ID : BUGLY_ID_TEST;
    NSString *savekey = [NSUserDefaultUtil GetDefaults:@"buglykey"];
    if (UG_CheckStrIsEmpty(savekey)) {
        [NSUserDefaultUtil PutDefaults:@"buglykey" Value: keys];
        savekey = keys;
    }
    [Bugly startWithAppId: savekey  config: config];
    
    [self loginState];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(loginState) name:@"LOGINSUCCES" object:nil];
    [defaultCenter addObserver:self selector:@selector(userSignOut) name:@"登录失效" object:nil];
    [defaultCenter addObserver:self selector:@selector(userSignOut) name:@"用户点击退出登录" object:nil];
}

-(void)loginState{
    if ([UGManager shareInstance].hasLogged && [UGManager shareInstance].hostInfo.userInfoModel.member.ID.length>0) {
        [Bugly setUserIdentifier:[UGManager shareInstance].hostInfo.userInfoModel.member.ID];
    }else{
        [Bugly setUserIdentifier:@"0"];
    }
}

-(void)userSignOut{
    [Bugly setUserIdentifier:@"0"];
}

@end
