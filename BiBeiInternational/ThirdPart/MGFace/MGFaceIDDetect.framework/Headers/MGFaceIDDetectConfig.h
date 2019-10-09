//
//  MGFaceIDDetectConfig.h
//  FaceID
//
//  Created by MegviiDev on 2017/7/17.
//  Copyright © 2017年 megvii. All rights reserved.
//

#ifndef MGFaceIDDetectConfig_h
#define MGFaceIDDetectConfig_h
#import <UIKit/UIKit.h>



/**
 *  自助接入平台活体检测失败错误类型
 */
typedef enum : NSUInteger {
    ZZPlatformErrorUserCancel  = 56000,                   //  用户取消
    ZZPlatformErrorNoCameraPermission = 56000,            //  没有打开相机的权限，请开启权限后重试
    ZZPlatformErrorIllegalParameter = 56000,              //  传入参数不合法,error_start_detect_VC_nil
    ZZPlatformErrorDeviceNotSupport = 56000,              //  手机没有打开摄像头或者硬件不支持
    ZZPlatformErrorBundleId = 56000,                      //  此 APP 的bundle_id 在系统的黑名单库里
    ZZPlatformErrorNoNetPermission = 56000,               //  网络出错或者连不上互联网，请连接上互联网后重试
    ZZPlatformErrorFaceInitAuthentication = 56000,        //  无法启动人脸识别,SDK 鉴权失败
    ZZPlatformErrorLivenessDetectFailed = 56000,          //  活体检测不通过
    ZZPlatformErrorNoSensorPermission = 56000,            //  没有运动传感器权限（理论上不会出现）
    ZZPlatformErrorInitFailed = 56000,                   //  SDK 初始化失败
    
    ZZPlatformErrorReferToSamePerson = 51000,          //  待比对照片与数据源照片或参考照对比均是同一个人
    ZZPlatformErrorPassDetectButDifferentPeople = 52000, //  活体通过，但对比不是一个人
    
    ZZPlatformErrorNoIDCardNum = 53000,               //  权威数据错误可能无此身份证号
    ZZPlatformErrorIDCardMessageNotMatch = 53000,               //  身份证号，姓名不匹配
    ZZPlatformErrorNoFaceFound = 53000,               //  权威数据照片中找不到人脸
    ZZPlatformErrorNoIDFhoto = 53000,               //  权威数据照片中找不到图片
    ZZPlatformErrorPhotoFormat = 53000,               //  权威数据照片格式错误
    ZZPlatformErrorDataSource = 53000,               //  权威数据错误
    
    ZZPlatformErrorMaskAttack = 54100,                   //  假脸攻击
    ZZPlatformErrorChangeFaceAttack = 54100,                   //  换脸攻击
    
    
    
    ZZPlatformErrorBizToken = 54200,                     //  传入 biz_token 不符合要求
    ZZPlatformErrorBizConfig = 54200,                     //  传入 biz_config 不符合要求
    ZZPlatformErrorAuthenticationFail = 54200,                     //  鉴权失败
    ZZPlatformErrorMobilePhoneNotSupport = 54200,                     //  手机在不支持列表里
    ZZPlatformErrorSDKTooOld = 54200,                     //  SDK版本过旧，已经不被支持
    ZZPlatformErrorMobilePhoneNoAuthority = 54200,                     //  没有权限（运动传感器、存储、相机
    ZZPlatformErrorUserCancellation = 54200,                     //  用户取消了验证
    ZZPlatformErrorUserTimeOut = 54200,                     //  用户验证流程超时
    ZZPlatformErrorVerificationFailure = 54200,                     //  用户活体验证失败
    ZZPlatformErrorUndetectedFace = 54200,                     //  长时间没有检测到人脸
    ZZPlatformErrorAction = 54200,                     //  不符合动作提示
    
    ZZPlatformErrorSignInvalid = 55000,                     //  传入 sign 不符合要求
    ZZPlatformErrorSignVesionInvalid = 55000,                     //  传入 signVersion 不符合要求
    ZZPlatformErrorSignExpired = 55000,                     //  传入 sign 过期
    ZZPlatformErrorSignReplayAttack= 55000,                     //  重放攻击，单次有效的签名被多次使用
    ZZPlatformErrorApiKeyBeDiscontinued = 55000,                     //  api_key被停用
    ZZPlatformErrorIPNotAllowed = 55000,                     //  不允许访问的IP
    ZZPlatformErrorNonEnterpriseCertification = 55000,                     //  客户未进行企业认证
    ZZPlatformErrorBalanceNotEnough = 55000,                     //  余额不足
    ZZPlatformErrorMoreRetryTimes = 55000,                     //  超过重试次数
    ZZPlatformErrorAccountDiscontinued = 55000,                     //  用户帐号已停用
    
    ZZPlatformErrorLivingNotStart = 59000,                     //  活体验证没有开始
    ZZPlatformErrorLivingInProgress = 59000,                     //  正在进行验证
    ZZPlatformErrorLivingOverTime = 59000,                     //  操作超时，由于用户在长时间没有进行操作
} ZZPlatformErrorType;

typedef enum : NSUInteger {
    MGFaceIDDetectionZh = 0,
    MGFaceIDDetectionEn
} FaceIDDetectBundleLanguageKey;


/**
 *  动作活体检测阶段-UI用
 */
typedef enum : NSUInteger {
    MGActionLiveDetectStateDoing,
    MGActionLiveDetectStateSuccess,
    MGActionLiveDetectStateFailure,
} MGActionLiveDetectState;

/**
 *  动作类型
 */
typedef enum : NSUInteger {
    FaceIDDetectActionTypeBlink,                        //  眨眼
    FaceIDDetectActionTypeMouth,                        //  张嘴
    FaceIDDetectActionTypeYaw,                          //  左右摇头
    FaceIDDetectActionTypePitch,                        //  上下点头
} FaceIDDetectActionType;

/**
 *  活体初始化配置参数
 */
static NSString *const MGFaceIDFaceModel        = @"Meg_FaceRect";
static NSString *const MGFaceIDFaceLandmarkModel        = @"Meg_FaceLandmark";
static NSString *const MGFaceIDFMPLiveModel     = @"Meg_FMPLive";
static NSString *const MGFaceIDActionLiveModel  = @"Meg_ActionLive";
static NSString *const MGFaceIDFlashLiveModel   = @"Meg_FlashLive.bin";

static NSString *const MGFaceIDFaceModelName        = @"MGFaceIDMegLiveFaceModel";
static NSString *const MGFaceIDFaceLandmarkModelName        = @"MGFaceIDMegLiveFaceLandmarkModel";
static NSString *const MGFaceIDFMPLiveModelName     = @"MGFaceIDMegLiveFMPLiveModel";
static NSString *const MGFaceIDActionLiveModelName  = @"MGFaceIDMegLiveActionLiveModel";
static NSString *const MGFaceIDFlashLiveModelName   = @"MGFaceIDMegLiveFlashLiveModel";

typedef void(^FaceIDDetectBlock)(NSUInteger Code,NSString* Message);

typedef void(^FaceIDDetectOfflineResultBlock)(NSUInteger result, NSArray* videoPathList, NSDictionary* extraOutDataDict);

#endif /* MGFaceIDDetectConfig_h */
