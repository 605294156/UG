//
//  UGMessageApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMessageApi : UGBaseRequest
@property (nonatomic,strong) NSString *receiver;//接收者
@end

NS_ASSUME_NONNULL_END
