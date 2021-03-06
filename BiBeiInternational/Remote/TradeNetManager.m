//
//  TradeNetManager.m
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "TradeNetManager.h"

@implementation TradeNetManager
//查询盘口信息
+(void)getexchangeplate:(NSString *)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/exchange-plate";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提交委托
+(void)SubmissionOfentrustmentWithsymbol:(NSString*)symbol withPrice:(NSString*)price withAmount:(NSString*)amount WithDirection:(NSString*)direction withType:(NSString*)type CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;{
    NSString *path = @"exchange/order/add";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"price"] = price;
    dic[@"amount"] = amount;
    dic[@"direction"] = direction;
    dic[@"type"] = type;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//查询当前委托BUY-SELL
+(void)Querythecurrentdelegatesymbol:(NSString*)symbol withpageNo:(int)pageNo withpageSize:(int)pageSize  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/order/current";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"pageNo"] = [NSNumber numberWithInt:pageNo];
    dic[@"pageSize"] = [NSNumber numberWithInt:pageSize];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取单个UG钱包
+(void)getwallettWithcoin:(NSString*)coin  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"uc/asset/wallet",coin];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//取消委托
+(void)cancelCommissionwithOrderID:(NSString*)orderId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"exchange/order/cancel",orderId];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//获取单个交易对的精确度
+(void)getSingleSymbol:(NSString*)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/symbol-info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//查看历史委托
+(void)historyEntrustForSymbol:(NSString *)symbol withPageNo:(NSString *)pageNo withPageSize:(NSString*)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle
{
    NSString *path = @"exchange/order/history";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
@end
