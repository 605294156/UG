//
//  UGAdvertiseApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAdvertiseApi : UGBaseRequest

/**
 是否是修改交易
 */
@property (nonatomic , assign) BOOL reviseAdvertis;
@property (nonatomic, strong) NSString *ID;//修改交易才有
@property (nonatomic, strong) NSString *jyPassword;
@property (nonatomic, strong) NSString *price;

/**
 1 == 我要购买
 0 == 我要出售
 */
@property (nonatomic, strong) NSString *advertiseType;
@property (nonatomic, strong) NSString *coinId;
@property (nonatomic, strong) NSString *minLimit;
@property (nonatomic, strong) NSString *maxLimit;
@property (nonatomic, strong) NSString *timeLimit;
@property (nonatomic, strong) NSString *countryZhName;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *premiseRate;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *payMode;//后台需要一个list
@property (nonatomic, strong) NSString *isAuto;
@property (nonatomic, strong) NSString *autoword;



@end

NS_ASSUME_NONNULL_END
