//
//  UGGetIdentityNoApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 身份证号识别
 */
@interface UGGetIdentityNoApi : UGBaseRequest
- (id)initWithCardImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
