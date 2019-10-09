//
//  UGRegisterSendCodeApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/19.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGRegisterSendCodeApi : UGBaseRequest
@property(nonatomic,copy)NSString *phone;//会员登录名
@property(nonatomic,copy)NSString *areaCode;//区号
@property(nonatomic,copy)NSString *geetest_seccode;
@property(nonatomic,copy)NSString *geetest_challenge;
@property(nonatomic,copy)NSString *geetest_validate;
@end

NS_ASSUME_NONNULL_END
