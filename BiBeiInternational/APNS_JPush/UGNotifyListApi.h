//
//  UGNotifyListApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * SYSTEM_CHANGE_INFO：系统消息
 * DYNAMIC_CHANGE_INFO：动账消息
 * CHAT_INFO：聊天消息
 */
@interface UGNotifyListApi : UGBaseRequest
@property (nonatomic, assign) NSInteger currentPage;//默认是1
@property (nonatomic,strong) NSString *receiver;//接收者
@property (nonatomic,strong) NSString *status;//消息状态
@property (nonatomic,strong) NSString *parentMessageType;//消息类型
@end

NS_ASSUME_NONNULL_END
