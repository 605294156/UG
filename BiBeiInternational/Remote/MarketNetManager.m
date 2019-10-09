//
//  MarketNetManager.m
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MarketNetManager.h"

@implementation MarketNetManager
//查询我的自选
+(void)queryAboutMyCollectionCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/favor/find";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //版本号
    [dic setObject:APP_VERSION forKey:@"version"];
    //平台  0:安卓 1:IOS
    [dic setObject:@"1" forKey:@"platform"];
    [dic setObject:@"2" forKey:@"interfaceVersion"];
    NSString *iphoneType = [UG_MethodsTool iphoneType];
    [dic setObject: ! UG_CheckStrIsEmpty(iphoneType) ? iphoneType : @"" forKey:@"phoneModel"];
    
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//添加自选
+(void)addMyCollectionWithsymbol:(NSString*)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/favor/add";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //版本号
    [dic setObject:APP_VERSION forKey:@"version"];
    //平台  0:安卓 1:IOS
    [dic setObject:@"1" forKey:@"platform"];
    [dic setObject:@"2" forKey:@"interfaceVersion"];
    NSString *iphoneType = [UG_MethodsTool iphoneType];
    [dic setObject: ! UG_CheckStrIsEmpty(iphoneType) ? iphoneType : @"" forKey:@"phoneModel"];
    
    dic[@"symbol"] = symbol;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//删除自选
+(void)deleteMyCollectionWithsymbol:(NSString*)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/favor/delete";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //版本号
    [dic setObject:APP_VERSION forKey:@"version"];
    //平台  0:安卓 1:IOS
    [dic setObject:@"1" forKey:@"platform"];
    [dic setObject:@"2" forKey:@"interfaceVersion"];
    NSString *iphoneType = [UG_MethodsTool iphoneType];
    [dic setObject: ! UG_CheckStrIsEmpty(iphoneType) ? iphoneType : @"" forKey:@"phoneModel"];
    
    dic[@"symbol"] = symbol;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//获取USDT对CNY汇率
+(void)getusdTocnyRateCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/exchange-rate/usd-cny";

    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //版本号
    [dic setObject:APP_VERSION forKey:@"version"];
    //平台  0:安卓 1:IOS
    [dic setObject:@"1" forKey:@"platform"];
    [dic setObject:@"2" forKey:@"interfaceVersion"];
    NSString *iphoneType = [UG_MethodsTool iphoneType];
    [dic setObject: ! UG_CheckStrIsEmpty(iphoneType) ? iphoneType : @"" forKey:@"phoneModel"];
    
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
@end
