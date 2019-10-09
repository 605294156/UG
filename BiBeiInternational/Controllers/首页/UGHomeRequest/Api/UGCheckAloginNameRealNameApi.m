//
//  UGCheckAloginNameRealNameApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/9/20.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCheckAloginNameRealNameApi.h"

@implementation UGCheckAloginNameRealNameApi
-(NSString *)requestUrl{
    return @"ug/checkAloginNameRealNameStatus";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];//如果有父类 确定参数 如 设备号 就先拿到父类的
    [argument setObject:!UG_CheckStrIsEmpty(self.aloginName) ? self.aloginName : @"" forKey:@"aloginName"];
    return argument;
}
@end
