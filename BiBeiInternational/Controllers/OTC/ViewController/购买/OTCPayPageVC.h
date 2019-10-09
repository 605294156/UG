//
//  OTCPayPageVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CMMoneyStringBlock)(NSString *cmMoney);

@interface OTCPayPageVC : UGOTCBaseViewController

/**
 自己选择的支付的下标，需要去 orderDetailModel的 payModeList中用下标取出对应的值
 */
@property (nonatomic, assign) NSInteger payIndex;

@property(nonatomic,strong)UIImage *QRCodeImage;

@property(nonatomic,copy)NSString *cmPersonalTransferStr;

@property(nonatomic,copy)CMMoneyStringBlock cmBlock;

@end

NS_ASSUME_NONNULL_END
