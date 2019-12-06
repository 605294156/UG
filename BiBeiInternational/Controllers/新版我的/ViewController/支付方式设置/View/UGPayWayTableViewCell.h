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
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UILabel *bind;
@property (nonatomic, assign) BOOL  isLine;
@property (nonatomic, assign) BOOL  isSelectedPay;
@end

NS_ASSUME_NONNULL_END
