//
//  AppDelegate.m
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+NetWork.h"
#import "AppDelegate+Socket.h"
#import "AppDelegate+Guaid.h"
#import "AppDelegate+RemoteNotifications.h"
#import "AppDelegate+Appearance.h"
#import "AppDelegate+KeyboardManager.h"
#import "AppDelegate+Bugly.h"
#import "UGJPushHandle.h"
#import "AppDelegate+Pay.h"
#import "AppDelegate+QYSDK.h"
#import "QYSDK.h"
#import "AppDelegate+CheckAPPUpdate.h"

@interface AppDelegate()
 @property (strong, nonatomic)void(^completionHandler)(UIBackgroundFetchResult);
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #pragma mark - 解决plus横屏启动UI错乱问题
    application.statusBarOrientation = UIInterfaceOrientationPortrait;
    
    #pragma mark -清空一下视频存储数据
    [NSUserDefaultUtil PutDefaults:@"videoUrl" Value:@""];
    
    #pragma mark - 初始化Bugly
    [self start_Bugly];

    #pragma mark - 初始化应用语言
    [ChangeLanguage initUserLanguage];
    
    #pragma mark -注册系统通知
     [self registerNotificationCenter];
    
    #pragma mark -初始化网易七鱼
    [self ug_initQYSDKDidFinishLaunchingWithOptions:launchOptions];
    
    #pragma mark -初始化YTKNetworkConfig的全局配置
    [self settingYTKNetworkConfig];
    
    #pragma mark -初始化HUD样式
    [EasyShowOptions sharedEasyShowOptions].lodingShowType = LodingShowTypeTurnAround;
    
    #pragma mark -设置 UIScrollView UIBarButtonItem
    [self settingAppearance];
    
    #pragma mark -设置RootViewController
    [self settingRootViewController];

    #pragma mark -优先显示人民币
    self.isShowCNY = YES;
    
//    #pragma mark -UG对人民币的汇率 后面改动也可调接口
//    self.CNYRateToUG = @"1";
    
    #pragma mark -检测新版本
    [self checkUpdate];
    
    #pragma mark -通知接收
    [self receiveNotify];
    
    #pragma mark -添加官网快捷方式到桌面；
    [self startServer];
    //    #pragma mark -引导页
    //    [self showGuaid];
    
    //    #pragma mark -连接Socket
    //    [self connectSocket];
    
    //    #pragma mark -初始化键盘工具
    //    [self initKeyboardManager];
    
    return YES;
}

#pragma mark -通知接收
-(void)receiveNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucess:) name:@"LOGINSUCCES" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucess:) name:@"设置支付密码成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucess:) name:@"谷歌验证码绑定成功" object:nil];
}

#pragma mark -注册系统通知
-(void)registerNotificationCenter{
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else if (@available(iOS 8.0, *)) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    }
}

#pragma  mark - 登录成功消息
- (void)userLoginSucess:(NSNotification *)notification {
    if (self.orderString != nil) {
        [self handlePayOrderWithOrderString:self.orderString];
    }
}

#pragma mark - 设置rootViewController
- (void)settingRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    self.window.rootViewController = [UGTabBarController new];
    [self.window makeKeyAndVisible];
        
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        @strongify(self);
        [self showGestureLockViewController];
    });
}

#pragma mark -添加官网快捷方式到桌面；
- (void)startServer
{
    // Create server using our custom MyHTTPServer class
    _httpServer = [[RoutingHTTPServer alloc] init];
    [_httpServer setType:@"_http._tcp."];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [_httpServer setDocumentRoot:documentsDirectory];
    if (_httpServer.isRunning) [_httpServer stop];
    NSError *error;
    if([_httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [_httpServer listeningPort]);
        
        [_httpServer setPort:[_httpServer listeningPort]];
        
        
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
        [self startServer];
    }
}



#pragma mark- APP前后台操作
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    //发送socket消息
//    [self sendSocketMesssageWithDeviceToken:self.deviceToken];
    //开启后台任务
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //手势解锁页面
//    [self showGestureLockViewController];
    //发生socket消息
//    [self sendSocketMesssageWithDeviceToken:self.deviceToken];
    //结束后台任务
    [[UIApplication sharedApplication] endBackgroundTask:UIBackgroundTaskInvalid];
    //检测程序更新
    [self checkUpdate];
    //检测有无待办事项
    [[UGManager shareInstance] getOrderWaitingDealList:^(BOOL complete, NSMutableArray * _Nonnull object) {
        if (object.count>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"发现有待办事项" object:nil];
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //启动程序  如果是登录状态就去请求未读数
    if ([UGManager shareInstance].hasLogged) {
        [UGJPushHandle getMessageVCDataCompletionBlock:^(UGApiError *apiError, id object) {
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


#pragma mark-检测到程序被杀死
- (void)applicationWillTerminate:(UIApplication *)application {
    
    //发送socket消息
//    [self sendSocketMesssageWithDeviceToken:self.deviceToken];
}

#pragma mark - 推送相关
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {    
    //网易七鱼 注册toaken
    [self ug_QYSDKRegisterDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    id object = [userInfo objectForKey:@"nim"]; //含有“nim”字段，就表示是七鱼的消息
    if (object)
    {
        //网易七鱼 接收消息
        [self ug_QYSDKDidReceiveRemoteNotification:userInfo];
    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"ios10以上 点击远程推送");
    }else{
        NSLog(@"ios10以上 点击本地推送");
    }
    //含有“nim”字段，就表示是七鱼的消息
    id object = [response.notification.request.content.userInfo objectForKey:@"nim"]; //含有“nim”字段，就表示是七鱼的消息
    if (object)
    {
        //网易七鱼 接收消息
        [self ug_QYSDKDidReceiveRemoteNotification:response.notification.request.content.userInfo];
    }
    completionHandler();
}

#pragma mark - openURL
/**
 *ios 9之前会调用这个
 */

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    return [self ug_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

/**
 *ios 9之后调用这个
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [self ug_application:app openURL:url options:options];
}

@end
