//
//  UGUploadImageRequest.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
#import "UGApiError.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGUploadImageRequest : UGBaseRequest

- (instancetype)initWithImage:(UIImage *)image;

- (instancetype)initWithImage:(UIImage *)image fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
