//
//  UGAdvertiseApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdvertiseApi.h"

@implementation UGAdvertiseApi

- (NSString *)requestUrl {
    if (self.reviseAdvertis) {
//        return @"otc/advertise/update";
        return @"/ug/otcv2/update";
    }
//    return @"otc/advertise/create";
    return @"/ug/otcv2/publishAdvertise";
}

- (NSTimeInterval)requestTimeoutInterval{
    return 60;
}

- (id)requestArgument {
    NSMutableDictionary *dic = [super requestArgument];
    if (self.reviseAdvertis) {
        dic[@"advertiseId"] = self.ID;
    }
    if (!UG_CheckStrIsEmpty(self.price)) {
        dic[@"price"] = self.price;
    }
    if (!UG_CheckStrIsEmpty(self.coinId)) {
        dic[@"coinId"] = self.coinId;
    }
    if (!UG_CheckStrIsEmpty(self.timeLimit)) {
        dic[@"timeLimit"] = self.timeLimit;
    }
    if (!UG_CheckStrIsEmpty(self.countryZhName)) {
        dic[@"countryZhName"] = self.countryZhName;
    }
    if (!UG_CheckStrIsEmpty(self.priceType)) {
        dic[@"priceType"] = self.priceType;
    }
    if (!UG_CheckStrIsEmpty(self.premiseRate)) {
        dic[@"premiseRate"] = self.premiseRate;
    }
    if (!UG_CheckStrIsEmpty(self.isAuto)) {
        dic[@"isAuto"] = self.isAuto;
    }
    if (!UG_CheckStrIsEmpty(self.autoword)) {
        dic[@"autoword"] = self.autoword;
    }
    if (!UG_CheckStrIsEmpty(self.advertiseType)) {
        dic[@"advertiseType"] = self.advertiseType;
    }
    if (!UG_CheckStrIsEmpty(self.minLimit)) {
        dic[@"minLimit"] = self.minLimit;
    }
    if (!UG_CheckStrIsEmpty(self.maxLimit)) {
        dic[@"maxLimit"] = self.maxLimit;
    }
    dic[@"remark"] = self.remark;
    dic[@"number"] = self.number;
    dic[@"payMode"] = self.payMode;
    dic[@"jyPassword"] = self.jyPassword;
    return dic;
}


@end
