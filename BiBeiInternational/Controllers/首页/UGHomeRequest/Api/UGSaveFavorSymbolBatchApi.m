//
//  UGSaveFavorSymbolBatchApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGSaveFavorSymbolBatchApi.h"

@implementation UGSaveFavorSymbolBatchApi
-(NSString *)requestUrl{
    return @"ug/exchange/saveFavorSymbolBatch";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    if (self.symbolList.count > 0) {
        [argument setObject:self.symbolList forKey:@"symbolList"];
    }
    return argument;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
