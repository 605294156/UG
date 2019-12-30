//
//  UGURLConfig.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//


#import "UGURLConfig.h"


@implementation UGURLConfig


#warning 服务器域名   打包的时候一定要注意环境的切换

/** 开发环境服务器地址 */
NSString * __nonnull const UGDevelopBaseURL =@"http://192.168.0.46/";
/** 正式环境服务器地址 */
NSString * __nonnull const UGReleaseBaseURL = @"https://api.ugcoin.pro/";
/** 测试环境服务器地址 */
NSString * __nonnull const UGReleaseBaseURL_TEST = @"http://api.test.bibei.ph/";

+ ( NSString * __nonnull)domainName {
    return  [[UG_MethodsTool getBundleID] isEqualToString:BUNDLEID]  ?  @"ugcoin.pro" : @"test.bibei.ph";
}

+ ( NSString * __nonnull)domainHttpsName {
    return  [[UG_MethodsTool getBundleID] isEqualToString:BUNDLEID]  ?  @"https" : @"http";
}

/**
 是否为正式环境
 */
+ (BOOL)isReleaseState {
#ifdef DEBUG
    return [NSUSERDEFAULTS boolForKey:UG_IS_RELEASE];
#endif
    return YES;
}

/**
 服务器地址
 */
+ (NSString *)baseURL {
    return [self isReleaseState] ? ( [[UG_MethodsTool getBundleID] isEqualToString:BUNDLEID] ? UGReleaseBaseURL : UGReleaseBaseURL_TEST)   : UGDevelopBaseURL;
}

/**
是否为发布状态
*/
+ (BOOL)changeToReleaseState:(BOOL)isRelease {
#ifdef DEBUG
    //    _URLReleaseState = isRelease;
    [NSUSERDEFAULTS setBool:isRelease forKey:UG_IS_RELEASE];
#else
    // 正式环境不允许更换地址
    [NSUSERDEFAULTS setBool:YES forKey:UG_IS_RELEASE];
#endif
    [NSUSERDEFAULTS synchronize];
    return YES;
}


#pragma mark- 特殊接口集合

//服务与隐私条款
+(NSString *)serveApi{
    return  [NSString stringWithFormat:@"%@://doc.%@/agreement.html",[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

//邀请好友
+(NSString *)invitationApi{
    return  [NSString stringWithFormat:@"%@://ugpersonh5.%@/#/SignUp?",[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

//客服头像
+(NSString *)serverHeaderApi{
    return  [NSString stringWithFormat:@"%@://doc.%@/img/icon.jpg",[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

//帮助中心
+(NSString *)helpCenterApi:(NSString *)index{
    return  [NSString stringWithFormat:@"%@://doc.%@/help/help/help%@_new.html",[UGURLConfig domainHttpsName],[UGURLConfig domainName],index];
}

//分享广告
+(NSString *)shareADApi{
    return  [NSString stringWithFormat:@"%@://ugpersonh5.%@/#/Adv?",[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

//承兑商  充值 提示
+(NSString *)cardVipMessage{
    return  [NSString stringWithFormat:@"请您登陆网页版个人后台进行充值！\n %@://ugperson.%@",[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

//视频地址 改https
+(NSString *)videoHttpApi{
    return  [NSString stringWithFormat:@"%@://doc.ugcoin.pro/video/ug.mp4",[UGURLConfig domainHttpsName]];
}

//系统设置  主要用来测试  基本用不上
+(NSString *)changeSettingApi{
    return [NSString stringWithFormat:@"%@://api.%@/",[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

//旧版我的  用不上
+(NSString *)oldMyApi{
    return [NSString stringWithFormat:@"%@：%@://www.%@",LocalizationKey(@"webSite"),[UGURLConfig domainHttpsName],[UGURLConfig domainName]];
}

@end
