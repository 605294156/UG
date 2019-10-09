//
//  UGOTCListApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
#import "OTCFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCListApi : UGBaseRequest

@property (nonatomic, assign) NSInteger advertiseType;//0:购买 1:出售
@property (nonatomic, strong) NSNumber *currentPage;//当前页数
@property (nonatomic, strong) NSString *marketPrice;//CNY: UG 的比例需要单独获取
@property (nonatomic, strong) OTCFilterModel *filterModel;

@end

NS_ASSUME_NONNULL_END
