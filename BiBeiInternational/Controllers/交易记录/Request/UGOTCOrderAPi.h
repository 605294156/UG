//
//  UGOTCOrderAPi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCOrderAPi : UGBaseRequest

@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *status;

/**
 0 买入
 1 卖出
 */
@property (nonatomic, assign) NSInteger advertiseType;

@end

NS_ASSUME_NONNULL_END
