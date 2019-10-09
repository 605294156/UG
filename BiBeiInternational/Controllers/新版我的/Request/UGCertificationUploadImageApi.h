//
//  UGCertificationUploadImageApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//


//此类仅供高级认证使用
#import "UGUploadImageRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCertificationUploadImageApi : UGUploadImageRequest

/**
 是否缓存到币贝服务器,只有手持身份证才需要设置YES。默认NO
 */
@property(nonatomic, assign) BOOL saveInServer;

@end

NS_ASSUME_NONNULL_END
