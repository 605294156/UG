//
//  UGForgetLoginPwdSendCodeApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/22.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGForgetLoginPwdSendCodeApi : UGBaseRequest
@property (nonatomic, copy) NSString *phone;//---旧手机号
@property(nonatomic,copy)NSString *areaCode;//区号
@property(nonatomic,copy)NSString *geetest_seccode;
@property(nonatomic,copy)NSString *geetest_challenge;
@property(nonatomic,copy)NSString *geetest_validate;
@end

NS_ASSUME_NONNULL_END
