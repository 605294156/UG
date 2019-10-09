//
//  UGNewUpdatePasswordApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGNewUpdatePasswordApi : UGBaseRequest
//用户名
@property (nonatomic, strong) NSString *username;
//谷歌验证码
@property (nonatomic, strong) NSString *code;
//新密码
@property (nonatomic, strong) NSString *nPassword;
//手机号
@property (nonatomic, strong) NSString *phone;
//人脸识别验证码
@property (nonatomic, strong) NSString *faceToken;

@property(nonatomic,assign)BOOL isVerify;//区别获取验证码
@end

NS_ASSUME_NONNULL_END
