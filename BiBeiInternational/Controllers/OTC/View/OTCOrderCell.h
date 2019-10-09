//
//  OTCOrderCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGButton.h"
#import "UGOTCAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCOrderCell : UGBaseTableViewCell

@property (weak, nonatomic) IBOutlet UGButton *buyButton;
@property(nonatomic, copy) void(^buyClickHandle)(id  sender);
@property(nonatomic, assign) BOOL isBuy;
@property (nonatomic, strong) UGOTCAdModel *model;

@end

NS_ASSUME_NONNULL_END
