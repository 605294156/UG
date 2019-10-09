//
//  UGBillDetailApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBillDetailApi.h"

@implementation UGBillDetailApi
-(NSString *)requestUrl{
    return @"ug/app/pay/order-detail";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.orderType)?self.orderType:@"" forKey:@"orderType"];
    [argument setObject:!UG_CheckStrIsEmpty(self.orderSn)?self.orderSn:@"" forKey:@"orderSn"];
    return argument;
}
@end
