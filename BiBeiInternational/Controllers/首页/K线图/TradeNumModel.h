//
//  TradeNumModel.h
//  CoinWorld
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeNumModel : NSObject
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *direction;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *time;

//后加
@property(nonatomic,copy)NSString *amountStr;
@property(nonatomic,copy)NSString *priceStr;

@end
