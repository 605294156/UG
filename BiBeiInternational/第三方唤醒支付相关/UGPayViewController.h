//
//  UGPayViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/15.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayViewController : UGBaseViewController

@property (nonatomic, strong) UGOrder *orderModel;
@property(nonatomic, strong) NSString *fomeScheme;

@end

NS_ASSUME_NONNULL_END
