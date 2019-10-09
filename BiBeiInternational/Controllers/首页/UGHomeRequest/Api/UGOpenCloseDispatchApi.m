//
//  UGOpenCloseDispatchApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGOpenCloseDispatchApi.h"

@implementation UGOpenCloseDispatchApi
-(NSString *)requestUrl{
    return @"ug/appIntegration/openCloseDispatch";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.openingOrderStatus) ? self.openingOrderStatus:@"" forKey:@"openingOrderStatus"];
    return argument;
}
@end
