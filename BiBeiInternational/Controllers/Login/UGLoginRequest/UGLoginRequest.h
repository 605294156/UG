//
//  UGLoginRequest.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGBaseRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface UGLoginRequest : NSObject

@property(nonatomic,copy)NSString *username;//会员登录名
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *country;//国家
@property(nonatomic,copy)NSString *areaCode;//区号


/**
 发起登录请求
 UGLoginRequest ：登录UG钱包 -> 拉取个人信息 -> 登录jIM

 @param completionBlock 请求回调，成功obje = UGHost;
 */
- (void)ug_startLoginWithCompletionBlock:(UGRequestCompletionBlock)completionBlock;


@end

NS_ASSUME_NONNULL_END
