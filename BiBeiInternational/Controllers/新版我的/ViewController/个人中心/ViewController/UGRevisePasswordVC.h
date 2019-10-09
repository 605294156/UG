//
//  UGRevisePasswordVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGRevisePasswordVC : UGBaseViewController


@property(nonatomic,strong)UIViewController *topVC;
/**
 登录页面过来
 */
@property(nonatomic, assign) BOOL fromeLogin;

/**
  存在上个页面输入的情况 所以用户名传过来
 */
@property(nonatomic, copy) NSString *username;

/**
 人脸识别过来的
 */
@property(nonatomic, assign) BOOL fromeFace;

/**
 人脸识别验证码带过来
 */
@property(nonatomic, copy) NSString *faceCode;

/**
  助记词界面带过来的助记词
 */
@property(nonatomic,copy)NSString *auxiliaries;
/**
 是否是助记词重置登录密码密码
 */
@property(nonatomic,assign)BOOL fromAuxiliaries;


@end

NS_ASSUME_NONNULL_END
