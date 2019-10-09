//
//  UGBillTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@class UGOrderListModel;

@interface UGBillTableViewCell : UGBaseTableViewCell

@property(nonatomic, strong) UGOrderListModel *orderListModel;

@end

NS_ASSUME_NONNULL_END
