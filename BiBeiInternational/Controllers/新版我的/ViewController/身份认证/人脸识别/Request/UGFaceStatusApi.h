//
//  UGFaceStatusApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGFaceStatusApi : UGBaseRequest
@property (nonatomic,copy)NSString *bizToken; //鉴权token
@end

NS_ASSUME_NONNULL_END
