//
//  UGManager.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGLoginApi.h"
#import "UGHost.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UGCheckFaceIDOrTouchID){
    /**
     *  设备不支持 FaceID 也不 支持TouchID
     */
    UGNotSupportFaceIDOrTouchID = 0,
    
    /**
     * 设备支持 TouchID
     */
    UGSupportTouchID = 1,
    
    /**
     *  设备支持 FaceID
     */
    UGSupportFaceID = 2,
    
    /**
     *  检测失败
     */
    UGCheckFail = 3,
};

@interface UGManager : NSObject


+ (instancetype) shareInstance;

/**
 登录返回信息以及拉取个人信息接口
 */
@property(nonatomic, strong) UGHost *hostInfo;



/**
 交易功能是否被限制

 @return 被限制还是未被限制
 */
- (BOOL)userTransactionDisable;


/**
 是否绑定了任何支付方式
  支付宝、微信、银行卡 、云闪付其中一种
 */
- (BOOL)hasBindingPayMode;


/**
是否绑定了谷歌验证器
 */
- (BOOL)hasBindingGoogleValidation;

/**
 获取高级认证状态  0：审核中  1:失败  2：成功
 */
- (NSString *)getHighValidationAuditStatus;


/**
 是否已登录
 
 @return 返回当前登录状态
 */
- (BOOL)hasLogged;


/**
 退出登录

 @param completionBlock 退出成功回调
 */
- (void)signout:(void(^)(void))completionBlock;


/**
 登录接口 ：登录UG钱包 -> 拉取个人信息 -> 登录jIM

 @param userName 用户名即账号
 @param password 密码
 @param completionBlock 请求返回
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password country:(NSString *)country areaCode:(NSString *)areacode completionBlock:(UGRequestCompletionBlock)completionBlock;



/**
 自动登录即指纹、人脸识别登录
 @param completionBlock 请求返回
 */
- (void)autoLoginCompletionBlock:(UGRequestCompletionBlock)completionBlock;




/**
 获取用户详细信息，成功后自定刷新hostInfo.userInfoModel的值
 @param completionBlock 请求返回
 */
- (void)sendGetUserInfoRequestCompletionBlock:(UGRequestCompletionBlock)completionBlock;


/**
 更新保存的登录密码，修改登录密码后保存

 @param nPassword 新密码
 */
- (void)updatePasswordToSave:(NSString *)nPassword;


/**
 * 设置指纹登录状态
 */
-(void)hasTouchIDOrFaceIDVerifyValue:(NSString *)value;

/**
 * 获取指纹登录状态
 */
-(BOOL)getTouchIDOrFaceIDVerifyValue;

/**
 * 判断是FaceID 或者 TouchID
 */
-(UGCheckFaceIDOrTouchID)checkIsSupportFaceIDOrTouchID;


/**
 *  查询待办事项
 */
-(void)getOrderWaitingDealList:(void(^)(BOOL complete,NSMutableArray *object))completeHandle;

@end

NS_ASSUME_NONNULL_END
