//
//  UGMineAdListApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMineAdListApi : UGBaseRequest

@property (nonatomic, strong) NSNumber *currentPage;//当前页数
//@property (nonatomic, strong) NSString *marketPrice;//CNY: UG 的比例需要单独获取


@end

NS_ASSUME_NONNULL_END
