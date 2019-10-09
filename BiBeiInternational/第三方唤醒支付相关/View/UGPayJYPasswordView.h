//
//  UGPayJYPasswordView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayJYPasswordView : UIView

+(instancetype)fromXib;


@property (nonatomic, strong) UGOrder *orderModel;

@property (nonatomic, copy) void(^clickNextSetpHandle)(NSString *passWord);
@property (nonatomic, copy) void(^clickCloseHandle)(void);

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

NS_ASSUME_NONNULL_END
