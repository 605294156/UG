//
//  symbolModel.h
//  CoinWorld
//
//  Created by sunliang on 2018/2/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

@interface symbolModel : BaseModel
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,assign)double open;
@property(nonatomic,assign)double high;
@property(nonatomic,assign)double low;
@property(nonatomic,assign)double close;
@property(nonatomic,assign)double chg;
@property(nonatomic,assign)double change;
@property(nonatomic,assign)double volume;  //成交量
@property(nonatomic,assign)double turnover;//成交额
@property(nonatomic,assign)BOOL isCollect;//是否收藏
@property(nonatomic,assign)double lastDayClose;
@property(nonatomic,assign)double usdRate;
@property(nonatomic,assign)double usdMoney;
@property(nonatomic,assign)double baseUsdRate;
//新加
@property(nonatomic,copy)NSString *closeStr; //价格精确度字符串
@end
