//
//  UGupdateAllApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGupdateAllApi : UGBaseRequest
@property (nonatomic,strong)NSString *receiver;//消息接收者
@property (nonatomic,strong)NSString *parentMessageType;//消息的状态
@end

NS_ASSUME_NONNULL_END
