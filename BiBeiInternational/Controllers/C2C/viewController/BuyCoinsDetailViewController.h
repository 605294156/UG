//
//  BuyCoinsDetailViewController.h
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface BuyCoinsDetailViewController : UGBaseViewController

@property(nonatomic,copy)NSString *advertisingId;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,assign)NSInteger flagindex;//2买币 1卖币
@property(nonatomic,copy)NSString *headImage;//头像
@property(nonatomic,copy)NSString*remainAmount;//剩余数量

@end
