//
//  UGNewGuidStatusManager.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/14.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGNewGuidStatusManager.h"

@implementation UGNewGuidStatusManager

static UGNewGuidStatusManager* instance = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance ;
}

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [UGNewGuidStatusManager shareInstance];
}

-(id) copyWithZone:(struct _NSZone *)zone {
    return [UGNewGuidStatusManager shareInstance];
}

@end
