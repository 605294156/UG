//
//  AppDelegate.h
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutingHTTPServer.h"

typedef enum : NSUInteger {
   MINUTELINE=0,//1分钟
   HOURLINE,//1小时
   DAYLINE,//日K
   WEEKLINE //周K
} KlineType;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)KlineType klineType;
@property(nonatomic,assign)NSInteger startDrawIndex;//开始画K线点的序号
@property(nonatomic,assign)NSInteger kLineDrawNum;//画K线点的数量
@property(nonatomic,assign)BOOL isShowCNY;//行情价格是否显示为CNY
@property(nonatomic,copy)NSString* CNYRate;//人民币对美元的汇率
@property(nonatomic,copy)NSString* CNYRateToUG;//人民币对UG的汇率
@property (nonatomic, assign) NSInteger precisionNum;//精度
@property(nonatomic,strong)NSString *orderString;//第三方支付订单号
@property (strong, nonatomic, readonly) RoutingHTTPServer *httpServer;
@end

