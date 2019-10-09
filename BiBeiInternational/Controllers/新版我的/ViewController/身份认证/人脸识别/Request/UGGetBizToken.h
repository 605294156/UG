//
//  UGGetBizToken.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGGetBizToken : UGBaseRequest
/**
 * 更新人脸识别状态 UPDATE_FACESTATUS
 */

/**
 * 更新密码 UPDATE_PASSWORD
 */

/**
 * 更新谷歌验证码 UPDATE_GOOGLE
 */

/**
 *  修改交易密码 UPDATE_JYPASSWORD
 */
@property (nonatomic,copy)NSString *target; //人脸识别用于哪个功能

@property (nonatomic,copy)NSString *username; //用户名
@end

NS_ASSUME_NONNULL_END
