//
//  UGHomeChatTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "SWTableViewCell.h"
#import "UGChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGHomeChatTableViewCell : SWTableViewCell

@property (nonatomic, strong) UGChatModel *chatModel;


/**
 删除会话
 */
@property (nonatomic, copy) void((^deleteConversation)(UGChatModel *chatModel));


@end

NS_ASSUME_NONNULL_END
