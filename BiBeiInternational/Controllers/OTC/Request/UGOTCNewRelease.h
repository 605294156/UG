//
//  UGOTCNewRelease.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCNewRelease : UGBaseRequest
@property(nonatomic, strong) NSString *orderSn;
@property(nonatomic, strong) NSString *jyPassword;
@property(nonatomic, strong) NSString *code;//手机验证码
@property(nonatomic, strong) NSString *validType; //0 表示手机短信验证  1为谷歌验证
@property(nonatomic, strong) NSString *googleCode;
@end

NS_ASSUME_NONNULL_END
