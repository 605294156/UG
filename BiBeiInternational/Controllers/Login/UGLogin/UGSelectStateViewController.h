//
//  UGSelectStateViewController.h
//  BiBeiInternational
//
//  Created by XiaoCheng on 26/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGSelectStateViewController : UGBaseViewController
@property(nonatomic,strong)NSArray *areaTitles;
@property (nonatomic, strong) UGAreaModel *model;
@end

NS_ASSUME_NONNULL_END
