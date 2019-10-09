//
//  UGShelvesAdApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGShelvesAdApi.h"

@implementation UGShelvesAdApi

- (NSString *)requestUrl {
//    return  self.isOn ? @"/otc/advertise/off/shelves" : @"/otc/advertise/on/shelves";
    return  self.isOn ? @"/ug/otcv2/putOffShelves" : @"ug/otcv2/putOnShelves";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:self.advertiseId forKey:@"advertiseId"];
    return dict;
}

@end
