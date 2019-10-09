//
//  UGTouchIDTool.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
/**
 *  TouchID 状态
 */
typedef NS_ENUM(NSUInteger, UGTouchIDState){
    
    /**
     *  当前设备不支持TouchID
     */
    UGTouchIDStateNotSupport = 0,
    /**
     *  TouchID 验证成功
     */
    UGTouchIDStateSuccess = 1,
    
    /**
     *  TouchID 验证失败
     */
    UGTouchIDStateFail = 2,
    /**
     *  TouchID 被用户手动取消
     */
    UGTouchIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID,选择手动输入密码
     */
    UGTouchIDStateInputPassword = 4,
    /**
     *  TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    UGTouchIDStateSystemCancel = 5,
    /**
     *  TouchID 无法启动,因为用户没有设置密码
     */
    UGTouchIDStatePasswordNotSet = 6,
    /**
     *  TouchID 无法启动,因为用户没有设置TouchID
     */
    UGTouchIDStateTouchIDNotSet = 7,
    /**
     *  TouchID 无效
     */
    UGTouchIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)
     */
    UGTouchIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    UGTouchIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    UGTouchIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID (必须高于iOS 8.0才能使用)
     */
    UGTouchIDStateVersionNotSupport = 12
};

@interface UGTouchIDTool : LAContext

typedef void (^StateBlock)(UGTouchIDState state,NSError *error);


/**
 启动TouchID进行验证
 
 @param desc Touch显示的描述
 @param block 回调状态的block
 */

-(void)ug_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;

@end
