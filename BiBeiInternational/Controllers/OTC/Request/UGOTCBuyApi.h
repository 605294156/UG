//
//  UGOTCBuyApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCBuyApi : UGBaseRequest


@property (nonatomic, assign) BOOL isBuy;
@property (nonatomic, strong) NSString *advertisingId;
@property (nonatomic, strong) NSString *coinId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *amount;


@end

NS_ASSUME_NONNULL_END
