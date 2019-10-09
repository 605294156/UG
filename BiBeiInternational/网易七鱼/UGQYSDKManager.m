//
//  UGQYSDKManager.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGQYSDKManager.h"
#import "QYSDK.h"
#import "AppDelegate.h"
#import "UGNavController.h"
#import "OTCViewController.h"
#import "UGScheduleView.h"

static UGQYSDKManager* instance = nil;

@interface UGQYSDKManager()<UNUserNotificationCenterDelegate>

@end

@implementation UGQYSDKManager
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance ;
}

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [UGQYSDKManager shareInstance];
}

-(id) copyWithZone:(struct _NSZone *)zone {
    return [UGQYSDKManager shareInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showChatViewController:(NSDictionary *)remoteNotificationInfo
{
    id object = [remoteNotificationInfo objectForKey:@"nim"]; //含有“nim”字段，就表示是七鱼的消息
    if (object)
    {
        //将待办事项隐藏
        [UGScheduleView hidePopView];
        
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"UG钱包";
        [[UGQYSDKManager shareInstance] updateDateQYUserInfo:@"" isLogin:NO];
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = @"在线客服";
        sessionViewController.source = source;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"]  style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
        sessionViewController.navigationItem.leftBarButtonItem = leftItem;
        if (![[UIViewController currentViewController] isKindOfClass:[QYSessionViewController class]]) {
             UGNavController* navi = [[UGNavController alloc]initWithRootViewController:sessionViewController];
            [[UIViewController currentViewController] presentViewController:navi animated:YES completion:nil];
        }
    }
}
- (void)onBack:(id)sender {
    [[UIViewController currentViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -个人信息CRM 上报
-(void)updateDateQYUserInfo:(NSString *)sno isLogin:(BOOL)login{
    
    //设置界面头像
    [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"header_defult"];
    [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = login ? @" " : [UGManager shareInstance].hostInfo.userInfoModel.member.avatar;
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"message_kefu"];
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImageUrl = login ? @" " :  [UGManager shareInstance].hostInfo.userInfoModel.customerAvatar;
    [[QYSDK sharedSDK] customUIConfig].showHeadImage =YES;
    [[QYSDK sharedSDK] customUIConfig].rightItemStyleGrayOrWhite = NO;

    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = login ?  [UG_MethodsTool getNowTimeTimestamp3:NO]  :  [UGManager shareInstance].hostInfo.userInfoModel.member.ID;
    //用户姓名
    NSMutableArray *array = [NSMutableArray new];
    NSMutableDictionary *dictRealName = [NSMutableDictionary new];
    [dictRealName setObject:@"real_name" forKey:@"key"];
    [dictRealName setObject: login ? @"游客" : [UGManager shareInstance].hostInfo.username forKey:@"value"];
    [array addObject:dictRealName];
    
    //用户头像
    NSMutableDictionary *dictAvatar = [NSMutableDictionary new];
    [dictAvatar setObject:@"avatar" forKey:@"key"];
    [dictAvatar setObject: login ? @" " :[UGManager shareInstance].hostInfo.userInfoModel.member.avatar forKey:@"value"];
    [array addObject:dictAvatar];
    
    if ( ! login) {
        //是否实名认证
        NSMutableDictionary *dictAuthentication = [NSMutableDictionary new];
        [dictAuthentication setObject:@(0) forKey:@"index"];
        [dictAuthentication setObject:@"authentication" forKey:@"key"];
        [dictAuthentication setObject:@"实名认证" forKey:@"label"];
        [dictAuthentication setObject:[UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation ? @"已认证" : @"未认证" forKey:@"value"];
        [array addObject:dictAuthentication];
    }

    if (!UG_CheckStrIsEmpty(sno)) {
        //订单号
        NSMutableDictionary *dictOrderSno= [NSMutableDictionary new];
        [dictOrderSno setObject:@(1) forKey:@"index"];
        [dictOrderSno setObject:@"orderSn" forKey:@"key"];
        [dictOrderSno setObject:@"订单号" forKey:@"label"];
        [dictOrderSno setObject:sno forKey:@"value"];
        [array addObject:dictOrderSno];
    }
   
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:0
                                                     error:nil];
    if (data)
    {
        userInfo.data = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"---网易七鱼个人信息上报%@------",userInfo.data);
    [[QYSDK sharedSDK] setUserInfo:userInfo];
}

#pragma mark -注销QYSDK此方法只在- 用户退出登录或者账号失效的时 执行
- (void)logoutQYSDK{
    [[QYSDK sharedSDK] logout:^(BOOL success) {
      NSLog(@"注销QYSDK");
    }];
}

@end
