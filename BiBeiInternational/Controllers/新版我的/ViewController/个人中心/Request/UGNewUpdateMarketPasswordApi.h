//
//  UGNewUpdateMarketPasswordApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGNewUpdateMarketPasswordApi : UGBaseRequest

//手机验证码
@property (nonatomic, strong) NSString *phone;
//谷歌验证码
@property (nonatomic, strong) NSString *code;
//新密码
@property (nonatomic, strong) NSString *nPassword;
//人脸识别  bizToken
@property (nonatomic, strong) NSString *bizToken;

@property(nonatomic,assign)BOOL isVerify;//区别获取验证码
@end

NS_ASSUME_NONNULL_END
