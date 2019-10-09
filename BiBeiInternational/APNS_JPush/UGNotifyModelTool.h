//
//  HFPostTagItemTool.h
//  HappyFishing_iPhone
//
//  Created by gL on 2017/11/28.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGRemotemessageHandle.h"
#import "UGJPushMesageModel.h"

@interface UGNotifyModelTool : NSObject

/**
 保存当前收到的消息
 */
+ (void)saveNotiyMessage:(UGBaseNotiyMessage *)notifyMessage;

/**
 获取当前收到的消息
 */
+ (NSArray <UGJPushMesageModel *>*)messageList;

@end
