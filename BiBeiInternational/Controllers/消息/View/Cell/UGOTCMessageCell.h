//
//  UGOTCMessageCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

#import "UGNotifyModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UGOTCMessageCell : UGBaseTableViewCell


/**
 OTC、交易消息
 */
@property (nonatomic, strong) UGNotifyModel *model;

/**
 点击查看详情
 */
@property(nonatomic, copy) void(^clickDetailedHandle)(UGNotifyModel *model);



@end

NS_ASSUME_NONNULL_END
