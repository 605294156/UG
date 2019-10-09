//
//  UGUnbindGoogleApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 换绑获取谷歌验证码
 */
@interface UGUnbindGoogleApi : UGBaseRequest
@property (nonatomic, copy) NSString *key;//人脸成功存储的键值
@end

NS_ASSUME_NONNULL_END
