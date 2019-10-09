//
//  UGGetAuxiliariesApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetAuxiliariesApi.h"

@implementation UGGetAuxiliariesApi
-(NSString *)requestUrl{
    return @"ug/member/getAuxiliaries";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];//如果有父类 确定参数 如 设备号 就先拿到父类的
    return argument;
}
@end
