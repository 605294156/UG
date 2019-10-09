//
//  OTCFilterModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCFilterModel : UGBaseModel

@property (nonatomic, strong) NSArray *countrys;//国家名列表 ： 字符串
@property (nonatomic, strong) NSArray *payModes;//支付方式列表 ：字符串
@property (nonatomic, strong) NSString *marketPrice;//CNY: UG 的比例需要单独获取
@property (nonatomic, strong) NSString *highAmount;//最大数量
@property (nonatomic, strong) NSString *lowAmount;//最小数量
@property (nonatomic, strong) NSString *MaxLimitCount;//最大限量
@property (nonatomic, strong) NSString *minLimitCount;//最小限量

/**
 排序规则
 数量升序： number asc
 数量降序： number desc
 交易量升序： achieve asc
 交易量降序 ： achieve desc
 */
@property (nonatomic, strong) NSString *orderByClause;

@end

NS_ASSUME_NONNULL_END
