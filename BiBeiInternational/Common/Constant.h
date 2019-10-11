//
//  Constant.h
//  BaseProject
//
//  Created by YLCai on 16/11/11.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
#define USERINFO @"USERINFO"

#import "UIDevice+UGExpand.h"

//自定义block
typedef void(^ResultBlock)(id resultObject,int isSuccessed);


#define NSUSERDEFAULTS [NSUserDefaults standardUserDefaults]


//判断当前用户保存的URL是什么Host，此切换仅用于debug模式
#define UG_IS_RELEASE              @"UG_IS_RELEASE"



#define PicHOST @""//加载服务器图片，服务器给的是完整路径不需要本地再拼接域名。估计是为了少改代码所以直接弄成了空字符串。

#define MESSAGE @"message"
#define LOGINNOTIFICATION  @"loginNotification"
//国际化
#define LocalizationKey(key) [[ChangeLanguage bundle] localizedStringForKey:key value:nil table:@"English"]
//图片
#define UIIMAGE(name) [UIImage imageNamed:name]
//通过RGB设置颜色
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
/** 色值 RGB **/
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)
#define HEXCOLOR(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1]
#define COLOR_HEX(hexValue, al)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:al]

//主色调
//#define mainColor  kRGBColor(81, 107, 160)
#define mainColor  kRGBColor(23,71,131)
#define baseColor  kRGBColor(99,128,176)
#define RedColor   kRGBColor(222, 109, 101)    //红跌
#define GreenColor kRGBColor(86, 189, 139)  //绿涨
#define FontColor  kRGBColor(28, 53, 79)
#define commonLineColor  kRGBColor(235, 237, 243) //线的颜色
#define commonColor  kRGBColor(236,237, 243) //tableView背景颜色

//自定义打印
#ifdef DEBUG
#define DLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];\
[dateFormatter setTimeZone:timeZone];\
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ"];\
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"TIME：%s【FILE：%s--LINE：%d】FUNCTION：%s\n%s\n",[str UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,__PRETTY_FUNCTION__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
#else
# define DLog(...);
#endif

#define APPCONFIG_UNIT_LINE_WIDTH                (1/[UIScreen mainScreen].scale)      //常用线宽


//设备唯一标识符
#define UGUUID            [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define UUIDKey         @"UUIDKey"
#define USENAMEPASSWORD         @"USENAMEPASSWORD"//用户名和密码
#define ReUSENAMEPASSWORD         @"ReUSENAMEPASSWORD"//用户名和密码
#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度


#define APPLICATION     [UIApplication sharedApplication].delegate



//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\
// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}


//iPhoneX机型判断
 #define SafeAreaTopHeight ([UIDevice isIphoneXSeries] ? 88 : 64)
#define SafeAreaBottomHeight ([UIDevice isIphoneXSeries]  ? 34 : 0)
#define SafeIS_IPHONE_X ([UIDevice isIphoneXSeries] ? 50 : 30)
#define IS_IPHONE_X ([UIDevice isIphoneXSeries])
#define NavigationBarAdapterContentInsetTop (IS_IPHONE_X? 88.0f:64.0f) //顶部偏移

/** 获取APP名称 */
#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

/** 程序版本号 */

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]





//#ifndef weakify
//#if DEBUG
//#if __has_feature(objc_arc)
//#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
//#else
//#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
//#endif
//#else
//#if __has_feature(objc_arc)
//#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
//#else
//#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
//#endif
//#endif
//#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* Constant_h */
