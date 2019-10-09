//
//  UGauthOldPhone.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGauthOldPhone : UGBaseRequest
@property (nonatomic, copy) NSString *phone;//---旧手机号
@property (nonatomic, copy) NSString *code;//---验证码
@property (nonatomic, assign) BOOL isVerify;//---是否是验证码
@end

NS_ASSUME_NONNULL_END
