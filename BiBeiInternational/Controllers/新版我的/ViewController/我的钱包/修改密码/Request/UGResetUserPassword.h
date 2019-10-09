//
//  UGResetUserPassword.h
//  BiBeiInternational
//
//  Created by conew on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGResetUserPassword : UGBaseRequest

//助记词
@property (nonatomic, copy) NSString *auxiliaries;
//新密码
@property (nonatomic, copy) NSString *password;
//修改类型 1：修改登录密码，2：修改支付密码
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
