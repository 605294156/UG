//
//  UGRevisePasswordApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGRevisePasswordApi : UGBaseRequest
//用户名
@property (nonatomic, strong) NSString *username;
//谷歌验证码
@property (nonatomic, strong) NSString *googleCode;
//新密码
@property (nonatomic, strong) NSString *nPassword;
//人脸识别验证码
@property (nonatomic, strong) NSString *faceToken;

@end

NS_ASSUME_NONNULL_END
