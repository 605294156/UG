//
//  UGOrderCancelApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOrderCancelApi.h"

@implementation UGOrderCancelApi
-(NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@",@"exchange/order/cancel/",!UG_CheckStrIsEmpty(self.orderId)?self.orderId:@""];
}
@end
