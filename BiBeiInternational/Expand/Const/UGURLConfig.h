//
//  UGURLConfig.h
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//BundleID
//正式上架  环境
static NSString * const BUNDLEID = @"com.gt.bub";//@"coin.ugpro.bibei";

//网易七鱼
//正式上架环境
static NSString * const QYSDKAPPKEY = @"6e52a885f756d9344c5df46cdfab3a32"; // 网易七鱼appKey
//测试环境
static NSString * const QYSDKAPPKEY_TEST = @"b538ef8c8a7cbd392b6a0b34ee617c0f"; // 网易七鱼appKey

#if DEBUG
static NSString * const QYSDKNAME = @"UG-Test"; // 网易七鱼app名称
#else
static NSString * const QYSDKNAME = @"UG钱包"; // 网易七鱼app名称
#endif


//腾讯Bugly_ID Bugly_Keyush
//正式上架环境
static NSString * const BUGLY_ID = @"3ce362b58f";
static NSString * const BUGLY_KEY = @"81994764-3ff2-43b5-be0d-f1a7d64ae002";
//测试环境
static NSString * const BUGLY_ID_TEST = @"807ad4c51f";
static NSString * const BUGLY_KEY_TEST = @"a704282d-444e-47bd-ab1d-567e1fdc1908";


@interface UGURLConfig : NSObject

/** 服务器地址 */
+ ( NSString * __nonnull)baseURL;

/** 服务器域名 */
+ ( NSString * __nonnull)domainName;

/** 服务器域名 */
+ ( NSString * __nonnull)domainHttpsName;

/** 更改发布状态 */
+ (BOOL)changeToReleaseState:(BOOL)isRelease;

#pragma mark- 特殊接口集合
//服务与隐私条款
+(NSString *)serveApi;

//邀请好友
+(NSString *)invitationApi;

//客服头像
+(NSString *)serverHeaderApi;

//帮助中心
+(NSString *)helpCenterApi:(NSString *)index;

//分享广告
+(NSString *)shareADApi;

//承兑商  充值 提示
+(NSString *)cardVipMessage;

//视频地址 改https
+(NSString *)videoHttpApi;

//系统设置  主要用来测试   基本用不上
+(NSString *)changeSettingApi;

//旧版我的   用不上
+(NSString *)oldMyApi;


@end

NS_ASSUME_NONNULL_END
