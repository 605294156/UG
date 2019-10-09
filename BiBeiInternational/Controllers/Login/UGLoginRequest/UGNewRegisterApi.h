//
//  UGNewRegisterApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGNewRegisterApi : UGBaseRequest
@property(nonatomic,copy)NSString *mobilePhone;//会员登录名
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *code;//短信验证码
@property(nonatomic,copy)NSString *areaCode;//区号
@property(nonatomic,copy)NSString *country;//国家
@end

NS_ASSUME_NONNULL_END
