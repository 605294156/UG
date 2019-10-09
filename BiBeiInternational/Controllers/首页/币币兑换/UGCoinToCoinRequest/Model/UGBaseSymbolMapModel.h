//
//  UGBaseSymbolMapModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
/**
 币币模型
 */
@interface UGBaseSymbolMapModel : UGBaseModel
@property(nonatomic,strong)NSString *symbol;/*币对展示*/
@property(nonatomic,strong)NSString *baseCoinScale;/*基础币精度*/
@property(nonatomic,strong)NSString *baseSymbol;/*基础币*/
@property(nonatomic,strong)NSString *coinScale;/*兑换币精度*/
@property(nonatomic,strong)NSString *coinSymbol;/*兑换币*/
@property(nonatomic,strong)NSString *enable;
@property(nonatomic,strong)NSString *fee;/*交易手续费*/
@property(nonatomic,strong)NSString *sort;
@property(nonatomic,strong)NSString *enableMarketBuy;/*市场价买入*/
@property(nonatomic,strong)NSString *enableMarketSell;/*市场价卖出*/
@property(nonatomic,strong)NSString *flag;
@property(nonatomic,strong)NSString *maxTradingOrder;
@property(nonatomic,strong)NSString *maxTradingTime;
@property(nonatomic,strong)NSString *minSellPrice;/*最低挂单卖价*/
@property(nonatomic,strong)NSString *minTurnover;/*最小挂单成交额*/
@property(nonatomic,strong)NSString *zone;/*交易区域*/
@property(nonatomic,strong)NSString *baseFee;/*结算币种手续费*/
@property(nonatomic,strong)NSString *maxVolume;/*最大下单量*/
@property(nonatomic,strong)NSString *minVolume; /*最小下单量*/
@end
