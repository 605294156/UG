//
//  TOCBuyDetailViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGOTCAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOCBuyDetailViewController : UGBaseViewController

@property (nonatomic, strong) UGOTCAdModel *model;
@property(nonatomic, assign) BOOL isBuy;

@end

NS_ASSUME_NONNULL_END
