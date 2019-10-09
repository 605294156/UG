//
//  UGUpdateVideoAndImageApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGUpdateVideoAndImageApi : UGBaseRequest
@property (nonatomic,copy)NSString *validateData;//唇语验证码
@property (nonatomic,copy)NSString *userId;//用户id
@property (nonatomic,copy)NSString *username;//用户名
- (id)initWithVideoPath:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
