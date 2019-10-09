//
//  UGOrderListApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//


typedef NS_ENUM(NSInteger, UGAppClassType) {
    UGAppClassType_All = -1,//全部
    UGAppClassType_outlay,//支出
    UGAppClassType_Income,//收入
};

#import "UGBaseRequest.h"
/**
 获取UG钱包记录列表
 */
@interface UGOrderListApi : UGBaseRequest


/**
 传入的是标题，内部转换
 */
@property (nonatomic,strong)NSString *searchType;

/**
 赛选条件
 */
@property (nonatomic, assign) UGAppClassType appClassType;

@property (nonatomic, strong) NSNumber *currentPage;//当前页数


@end
