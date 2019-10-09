//
//  UGConst.h
//  CommonProject
//
//  Created by conew on 2018/9/18.
//  Copyright © 2018年 conew. All rights reserved.
//

#ifndef UGConst_h
#define UGConst_h

#import "UIDevice+UGExpand.h"

//屏幕适配
#define UG_SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define UG_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define UG_Is_iPhoneXSeries    [UIDevice isIphoneXSeries]

#define UG_AutoSize(value)  ([UG_MethodsTool UGAutoSize:value])
#define UG_AutoFont(value)  ([UG_MethodsTool UGAutoFont:value])
#define UG_StatusBarAndNavigationBarHeight (UG_Is_iPhoneXSeries ? 88.f : 64.f)
#define UG_SafeAreaBottomHeight   (UG_Is_iPhoneXSeries ? 34.f : 0.f)//底部安全距离
#define UG_TabBarBottomHeight   (UG_Is_iPhoneXSeries ? 83.f : 49.f)
// 当前语言
#define UG_CURRENTLANGUAGE     ([[NSLocale preferredLanguages] objectAtIndex:0])

//Release版本用来屏蔽Log日志, 平时为被注释状态
#if DEBUG
#warning NSLogs will be shown
#else
#define NSLog(...) {}
#endif

//判断非空数组与字符串
#define UG_CheckStrIsEmpty(obj)     ([obj isKindOfClass:[NSNull class]] || !obj || [obj length]<1)
#define UG_CheckArrayIsEmpty(obj)   ([obj isKindOfClass:[NSNull class]] || obj == nil || obj.count == 0)

//颜色
#define UG_UIColorFromHex(value)        UG_UIColorFromHexA(value,1.0f)
#define UG_UIColorFromHexA(value,a)     ([UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0 green:((float)((value & 0xFF00) >> 8)) / 255.0 blue:((float)(value & 0xFF)) / 255.0 alpha:a])
#define UG_UIColorFromRGBA(r,g,b,a)     ([UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a])
#define  UG_UIColorFromRGB(r,g,b)       UG_UIColorFromRGBA(r,g,b,1.0f)


// View 圆角和加边框
#define UG_SetViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define UG_SetViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


//风格宏定义
#define UG_MainColor          [UIColor colorWithHexString:@"108BE4"]
#define UG_GaryFontColor     [UIColor colorWithHexString:@"BBBBBB"]
#define UG_WhiteColor        [UIColor whiteColor]
#define UG_BlackColor        [UIColor blackColor]
#define Color_GreenX            @"03c087"
#define Color_RedX                @"FF6978"



//字号
#define UGSystemFont(float)    [UIFont systemFontOfSize:float]

#endif /* UGConst_h */
