//
//  UGWechaPayViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGBindWechatPayApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGWechaPayViewController : UGBaseViewController

@property(nonatomic, assign) UGPayType payType;

@property(nonatomic, assign) BOOL updateBind;

@property(nonatomic,strong)UIViewController *topVC;

@property(nonatomic, copy) void(^handle)(void);


@end

NS_ASSUME_NONNULL_END
