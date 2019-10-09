//
//  UGOTCAdModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGOTCPayDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCAdModel : UGBaseModel

@property (nonatomic, copy) NSString *advertiseType;//0 购买列表 1 出售列表
@property (nonatomic, copy) NSString *coinName;//币种名字 : UG ETH
@property (nonatomic, copy) NSString *remainAmount;//剩余可购买数量
@property (nonatomic, copy) NSString *price;//单价
@property (nonatomic, copy) NSString *maxLimit;//最大限购量
@property (nonatomic, copy) NSString *minLimit;//最低限购量
@property (nonatomic, copy) NSString *username;//用户名
@property (nonatomic, copy) NSString *avatar;//用户头像
@property (nonatomic, copy) NSString *number; //交易中的数量,该交易的总数量
@property (nonatomic, strong) UGOTCPayDetailModel *payDetail;//支持的支付方式
@property (nonatomic, copy) NSString *achieve;//交易量
@property (nonatomic, copy) NSString *ID;//交易ID
@property (nonatomic, copy) NSString *remark;//卖家、买家备注
@property (nonatomic, copy) NSString *coinId;//币种的ID
@property (nonatomic, copy) NSString *successRate;//成功率

@property (nonatomic, copy) NSString *cardMember;//1 承兑商发布的交易  0 普通用户发布的交易
@property (nonatomic, copy) NSString *feeRate;
@property (nonatomic, copy) NSString *frozenAmount;
@property (nonatomic, copy) NSString *remainFrozenAmount;
@property(nonatomic,copy)NSString *payMode;

//1 的时候只显示删除按钮
@property (nonatomic, copy) NSString *offShelvesType;
/**
 修改交易后的支付方式
 */
@property (nonatomic, copy) NSArray <NSString *>*payWays;


/**
 交易状态
 0 已上架
 1 已下架
 2 删除
 */
@property (nonatomic, copy) NSString *status;



- (NSString *)advertiseTypeConvertToString;

/**
 卖家和买家的支付方式是否有一种匹配
 
 */
- (BOOL)checkPayModeMatch ;

/**
 返回买家的支付方式
 */
-(NSString *)machPayModelStr;

@end

NS_ASSUME_NONNULL_END
