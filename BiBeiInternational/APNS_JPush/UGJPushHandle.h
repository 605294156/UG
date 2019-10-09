//
//  HFMinPushHandle.h
//  HappyFishing_iPhone
//
//  Created by gL on 2017/2/21.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGRemotemessageHandle.h"

@interface UGJPushHandle : NSObject

+ (void)controlJPush:(UGBaseNotiyMessage *)messageModel;

//+ (void)oepnSafariWithUrl:(NSString *)urlString;

+(void)popViewShow:(UGBaseNotiyMessage *)model;

#pragma mark - 设置icon 角标  标签栏角标  服务器角标
+(void)setBageWith:(NSInteger)bageNum;

#pragma mark - 拿到目前消息未读数
+ (void)getMessageVCDataCompletionBlock:(UGRequestCompletionBlock)completionBlock;

#pragma mark - 消息状态修改（接收者和消息的类型）
+ (void)updateMessageWithType:(NSString *)parentMessageType CompletionBlock:(UGRequestCompletionBlock)completionBlock;
@end
