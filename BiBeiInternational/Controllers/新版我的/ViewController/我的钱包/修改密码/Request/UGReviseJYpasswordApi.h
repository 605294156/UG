//
//  UGReviseJYpasswordApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGReviseJYpasswordApi : UGBaseRequest

//谷歌验证码
@property (nonatomic, strong) NSString *code;
//新密码
@property (nonatomic, strong) NSString *nPassword;
//人脸识别  bizToken
@property (nonatomic, strong) NSString *bizToken;

@end

NS_ASSUME_NONNULL_END
