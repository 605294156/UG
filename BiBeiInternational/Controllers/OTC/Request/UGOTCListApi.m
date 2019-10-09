//
//  UGOTCListApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCListApi.h"

@implementation UGOTCListApi

- (NSString *)requestUrl {
    //    return @"/ug/otc/advertisePageList";
    return @"/ug/otcv2/advertisePageListAll";
}


- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

-(NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:@(self.advertiseType) forKey:@"advertiseType"];
    [dict setObject:self.currentPage forKey:@"currentPage"];
    [dict setObject:self.marketPrice forKey:@"marketPrice"];
    [dict setObject:@"0" forKey:@"status"];//后台要求写死的
    NSString *userId = [UGManager shareInstance].hostInfo.ID;
    [dict setObject:userId.length > 0 ? userId : @"" forKey:@"exceptMemberId"];
    [dict setObject:self.filterModel.highAmount.length > 0 ? self.filterModel.highAmount : @""  forKey:@"highAmount"];
    [dict setObject:self.filterModel.lowAmount.length > 0 ? self.filterModel.lowAmount : @""  forKey:@"lowAmount"];
    [dict setObject:self.filterModel.minLimitCount.length > 0 ? self.filterModel.minLimitCount : @""  forKey:@"minLimitCount"];
    [dict setObject:self.filterModel.MaxLimitCount.length > 0 ? self.filterModel.MaxLimitCount : @""  forKey:@"MaxLimitCount"];
    [dict setObject:self.filterModel.orderByClause.length > 0 ? self.filterModel.orderByClause : @"" forKey:@"orderByClause"];
    if (self.filterModel.countrys.count > 0) {
        [dict setObject:self.filterModel.countrys forKey:@"countrys"];
    }
    if (self.filterModel.payModes.count > 0) {
        [dict setObject:self.filterModel.payModes forKey:@"payModes"];
    }
    return dict;
}


/*
 @property (nonatomic, strong) NSString *highAmount;//最大数量
 @property (nonatomic, strong) NSString *lowAmount;//最小数量
 @property (nonatomic, strong) NSString *highPrice;//最高价格
 @property (nonatomic, strong) NSString *lowPrice;//最低价格
 @property (nonatomic, strong) NSString *orderByClause;//排序规则
 @property (nonatomic, strong) NSArray *countrys;//国家名列表
 @property (nonatomic, strong) NSArray *payModes;//支付方式列表

 */


@end
