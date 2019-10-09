//
//  UGOTCExchageModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCExchageModel : UGBaseModel

@property (nonatomic, strong) NSString * amount;/*数额*/
@property (nonatomic, strong) NSString * baseSymbol;/*基础币*/
@property (nonatomic, strong) NSString * canceledTime;/*订单取消时间*/
@property (nonatomic, strong) NSString * coinSymbol;/*交易币*/
@property (nonatomic, strong) NSString * completedTime;/*订单完成时间*/
@property (nonatomic, strong) NSString * direction;/*买入还是卖出*/
@property (nonatomic, strong) NSString * marginTrade; /*是否来自杠杆交易 0否 1是 */
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, strong) NSString * orderId;/*订单ID*/
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * status;/*状态 0交易中 1完成 2取消 3超时*/
@property (nonatomic, strong) NSString * symbol;/*币对展示  BTC/USDT */
@property (nonatomic, strong) NSString * time;/*订单时间*/
@property (nonatomic, strong) NSString * tradedAmount;/*交易量*/
@property (nonatomic, strong) NSString * turnover;
@property (nonatomic, strong) NSString * type;/*挂单类型 0市价 1限价*/

/*状态 0交易中 1完成 2取消 3超时*/
- (NSString *)stautsConvertToString;
@end

NS_ASSUME_NONNULL_END
