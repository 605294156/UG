//
//  OTCContentViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"
#import "OTCFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCContentViewController : UGTableViewController

@property(nonatomic, assign) BOOL isBuy;
@property (nonatomic, strong) OTCFilterModel *filterModel;

@end

NS_ASSUME_NONNULL_END
