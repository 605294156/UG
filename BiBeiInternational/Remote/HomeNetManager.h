//
//  HomeNetManager.h
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BaseNetManager.h"

@interface HomeNetManager : BaseNetManager
//获取交易币种缩略行情
+(void)getsymbolthumbCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询历史K线
+(void)historyKlineWithsymbol:(NSString*)symbol withFrom:(NSString*)formTime withTo:(NSString*)toTime withResolution:(NSString*)resolution CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//系统交易
+(void)advertiseBannerCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//首页数据
+(void)HomeDataCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//获取所有的盘口信息
+(void)platefullWithsymbol:(NSString*)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//获取成交记录
+(void)latesttradeWithsymbol:(NSString*)symbol withSizeSize:(int)size CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

@end
