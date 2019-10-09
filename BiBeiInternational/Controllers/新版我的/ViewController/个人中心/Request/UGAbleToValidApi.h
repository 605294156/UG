//
//  UGAbleToValidApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAbleToValidApi : UGBaseRequest
@property(nonatomic,copy)NSString *username;
@end

@interface UGAbleValidModel : UGBaseModel
@property(nonatomic,copy) NSString *hasGoogleValidation;//有没有进行谷歌验证码绑定
@property(nonatomic,copy)NSString *hasFaceValidation;//有没有进行人脸识别绑定
@property(nonatomic,copy)NSString *faceStatus;//用户人脸识别是否可用
@property(nonatomic,copy)NSString *bindAuxiliaries;//有没有绑定助记词
@end
NS_ASSUME_NONNULL_END
