//
//  UGPayRateApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayRateApi.h"

@implementation UGPayRateApi
-(NSString *)requestUrl{
    return @"ug/app/pay/payRate";
}

-(id)requestArgument{
    
    self.sloginName = [UGManager shareInstance].hostInfo.username;
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.rateType)?self.rateType:@"" forKey:@"rateType"];
    [argument setObject:!UG_CheckStrIsEmpty(self.sloginName)?self.sloginName:@"" forKey:@"sloginName"];
    
    return argument;
}
@end
