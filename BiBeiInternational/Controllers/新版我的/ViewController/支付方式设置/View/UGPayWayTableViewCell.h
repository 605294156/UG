//
//  UGPayWayTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGPayWayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayWayTableViewCell : UGBaseTableViewCell

@property(nonatomic, strong) UGPayWayModel *model;
@property (nonatomic, assign) BOOL isReleaseAd;//发布交易

@end

NS_ASSUME_NONNULL_END
