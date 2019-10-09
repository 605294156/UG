//
//  C2CNetManager.h
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BaseNetManager.h"

@interface C2CNetManager : BaseNetManager

//MARK:--获取商家认证状态
+(void)getBusinessStatusForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//选择币种
+(void)selectCoinTypeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//发布交易
+(void)advertisingForBuyOrSellWithPrice:(NSString *)price withAdvertiseType:(NSString*)advertiseType withCoinId:(NSString*)coinId withMinLimit:(NSString*)minLimit withMaxLimit:(NSString*)maxLimit withTimeLimit:(NSString*)timeLimit withCountry:(NSString*)country withPriceType:(NSString*)priceType withPremiseRate:(NSString*)premiseRate withRemark:(NSString*)remark withNumber:(NSString*)number withPayways:(NSMutableArray *)payWays withJyPassword:(NSString *)jyPassword withAuto:(NSString *)autoFlag withAutoWord:(NSString *)autoword  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//修改交易
+(void)changeAdvertisingForBuyOrSellWithAdvertisingId:(NSString *)advertisingId WithPrice:(NSString *)price withAdvertiseType:(NSString*)advertiseType withCoinId:(NSString*)coinId withMinLimit:(NSString*)minLimit withMaxLimit:(NSString*)maxLimit withTimeLimit:(NSString*)timeLimit withCountry:(NSString*)country withPriceType:(NSString*)priceType withPremiseRate:(NSString*)premiseRate withRemark:(NSString*)remark withNumber:(NSString*)number withPayways:(NSMutableArray *)payWays withJyPassword:(NSString *)jyPassword withAuto:(NSString *)autoFlag withAutoWord:(NSString *)autoword  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//分页交易查询
+(void)advertisingQueryForPageNo:(NSString *)pageNo withPageSize:(NSString *)pageSize withAdvertiseType:(NSString *)advertiseType withAdvertiseId:(NSString *)advertiseId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//买入，卖出交易信息
+(void)buyOrSelladvertiseInfoForid:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//卖出或买入货币
+(void)coinSellOrBuyForUrlString:(NSString *)urlString withAdvertisingId:(NSString *)advertisingId withCoinId:(NSString *)coinId withPrice:(NSString *)price withMoney:(NSString *)money withAmount:(NSString *)amount withRemark:(NSString *)remark withMode:(NSString *)mode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


@end
