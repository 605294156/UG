//
//  MGFaceIDDetectManager.h
//  MGFaceIDDetect
//
//  Created by MegviiDev on 2017/7/17.
//  Copyright © 2017年 megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGFaceIDDetectConfig.h"
@class FaceIDDetectError;
@class MGFaceIDDetectUIItem;
@class MGFaceIDDetectConfigItem;

@interface MGFaceIDDetectManager : NSObject

/**
 初始化FaceID活体检测

 @param token 业务串号
 @param error 错误返回
 @return 初始化对象
 */
- (instancetype _Nullable)initFaceIdManagerWithToken:(NSString *__nonnull)token error:(FaceIDDetectError *_Nonnull*__nonnull)error;

/**
 初始化FaceID活体检测
 
 @param token 业务串号
 @param hostUrlStr 指定host
 @param error 错误返回
 @return 初始化对象
 */
- (instancetype _Nullable)initFaceIdManagerWithToken:(NSString *__nonnull)token networkHostURL:(NSString *__nonnull)hostUrlStr error:(FaceIDDetectError *_Nonnull*__nonnull)error;


/**
 设置 FaceID 活体检测初始化语言，默认是中文
 
 @param liveDetectLanguage 初始化语言
 */
- (void)setMGFaceIDLiveDetectLanguage:(FaceIDDetectBundleLanguageKey)liveDetectLanguage;


/**
 *  启动 FaceID 检测
 *  @param detectVC 启动检测的VC
 *  @param result 检测结果的block回调。详情请考虑(MGFaceIDDetectConfig.h)
 */
- (void)startDetect:(UIViewController *__nonnull)detectVC callback:(FaceIDDetectBlock __nonnull)result;


///  SDK版本信息
+ (NSString *_Nonnull)getSdkVersion;


///  SDK构建信息
+ (NSString *_Nonnull)getSdkBuildInfo;

@end
