//
//  UGFaceRecognitionVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGFaceRecognitionVC : UGBaseViewController
@property(nonatomic,copy)void(^faceSuccessBlock)(void);
@property(nonatomic,assign)BOOL isReSettingPassWord;//从重置密码过来设置为YES  其他默认NO  1.重置密码  2.人脸认证  3.谷歌验证器换绑
@property(nonatomic,assign)BOOL isGoogle;//从谷歌验证器换绑页面过来设置为YES  其他默认NO
@property(nonatomic,assign)BOOL isLogin;//从登录页面过来设置为YES  其他默认NO
@property(nonatomic,copy)NSString *username;//从登录页面过来（未登录状态 需要username）
@property(nonatomic,strong)UIViewController *topVC;//定界面跳转
@end

NS_ASSUME_NONNULL_END
