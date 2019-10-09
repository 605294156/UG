//
//  UGLoginApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 UG登录api
 */
@interface UGLoginApi : UGBaseRequest
@property(nonatomic,copy)NSString *username;//会员登录名
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *country;//国家
@property(nonatomic,copy)NSString *areaCode;//区号
@end
