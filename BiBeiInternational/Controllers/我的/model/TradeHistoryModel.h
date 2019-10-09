//
//  TradeHistoryModel.h
//  CoinWorld
//
//  Created by iDog on 2018/3/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeHistoryModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *fee;
@end
