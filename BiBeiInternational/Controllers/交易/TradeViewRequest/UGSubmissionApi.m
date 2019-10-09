//
//  UGSubmissionApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSubmissionApi.h"

@implementation UGSubmissionApi
-(NSString *)requestUrl{
    return @"exchange/order/add";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.symbol)?self.symbol:@"" forKey:@"symbol"];
    [argument setObject:!UG_CheckStrIsEmpty(self.price)?self.price:@"" forKey:@"price"];
    [argument setObject:!UG_CheckStrIsEmpty(self.amount)?self.amount:@"" forKey:@"amount"];
    [argument setObject:!UG_CheckStrIsEmpty(self.direction)?self.direction:@"" forKey:@"direction"];
    [argument setObject:!UG_CheckStrIsEmpty(self.type)?self.type:@"" forKey:@"type"];
    return argument;
}
@end
