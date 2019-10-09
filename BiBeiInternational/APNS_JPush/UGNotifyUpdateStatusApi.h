//
//  UGNotifyUpdateStatusApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGNotifyUpdateStatusApi : UGBaseRequest
@property (nonatomic,strong)NSString *ids;//所修改消息的id
@end

NS_ASSUME_NONNULL_END
