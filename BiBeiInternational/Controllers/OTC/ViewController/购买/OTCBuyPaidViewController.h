//
//  OTCBuyPaidViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCBuyPaidViewController : UGOTCBaseViewController

/**
 自己选择的支付的下标，需要去 orderDetailModel的 payModeList中用下标取出对应的值
 */
@property (nonatomic, assign) NSInteger payIndex;

@end

NS_ASSUME_NONNULL_END
