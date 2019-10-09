//
//  UGRegisterApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 UG注册api
 */
@interface UGRegisterApi : UGBaseRequest
@property(nonatomic,copy)NSString *username;//会员登录名
@property(nonatomic,copy)NSString *password;//密码
@end
