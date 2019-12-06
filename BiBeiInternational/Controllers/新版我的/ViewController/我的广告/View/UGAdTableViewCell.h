//
//  UGAdTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGOTCAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAdTableViewCell : UGBaseTableViewCell

@property(nonatomic, strong) UGOTCAdModel *model;

@property(nonatomic, assign) BOOL isNotify;

@property (nonatomic, assign) BOOL  showShadow;

/**
 点击底部按钮
 status 底部按钮标题
 */
@property (nonatomic, copy) void (^clickButtonHandle)(NSString *status, UGOTCAdModel *model);

@end

NS_ASSUME_NONNULL_END
