//
//  UGShowBindPayInfoViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGBindWechatPayApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGShowBindPayInfoViewController : UGBaseViewController

@property(nonatomic, assign) UGPayType payType;

@property (nonatomic, copy) void (^clickUnBinding)(UGPayType payType);

@end

NS_ASSUME_NONNULL_END

