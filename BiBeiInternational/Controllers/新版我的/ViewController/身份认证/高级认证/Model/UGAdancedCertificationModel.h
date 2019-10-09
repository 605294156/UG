//
//  UGAdancedCertificationModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAdancedCertificationModel : UGBaseModel

@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *defaultImageName;//默认图片

@property(nonatomic, copy) NSString *submitImageUrlStr;//提交认证图片地址

@property(nonatomic, copy) NSData *value;//图片数据流


@end

NS_ASSUME_NONNULL_END
