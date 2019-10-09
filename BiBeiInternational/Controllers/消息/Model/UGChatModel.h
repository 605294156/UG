//
//  UGChatModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/15.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGChatModel : UGBaseModel
/**
 未读数
 */
@property (nonatomic, assign) NSInteger unreadCount;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *userName;


@end

NS_ASSUME_NONNULL_END
