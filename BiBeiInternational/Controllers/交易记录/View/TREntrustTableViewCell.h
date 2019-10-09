//
//  TREntrustTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGOTCExchageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TREntrustTableViewCell : UGBaseTableViewCell

//币币交易
@property (nonatomic, strong) UGOTCExchageModel *exchangeModel;


/**
 点击撤销
 */
@property (nonatomic, copy) void(^clickCancelHandle)(UGOTCExchageModel *exchangeModel);

@end

NS_ASSUME_NONNULL_END
