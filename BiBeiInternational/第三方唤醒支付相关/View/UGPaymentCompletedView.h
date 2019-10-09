//
//  UGPaymentCompletedView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPaymentCompletedView : UIView

+(instancetype)fromXib;

@property (nonatomic, strong) UGOrder *orderModel;
@property (nonatomic, copy) void(^completeHanlde)(void);


@end

NS_ASSUME_NONNULL_END
