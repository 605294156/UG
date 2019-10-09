//
//  UGExchangeApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGExchangeApi : UGBaseRequest

@property (nonatomic, strong) NSString *currentPage;

/**
 全部 0 交易中 1已完成 2.已取消 3.已超时
 */
@property (nonatomic, strong) NSString *status;

/**
 0 买入
 1 卖出
 */
@property (nonatomic, assign) NSInteger direction;


@end

NS_ASSUME_NONNULL_END
