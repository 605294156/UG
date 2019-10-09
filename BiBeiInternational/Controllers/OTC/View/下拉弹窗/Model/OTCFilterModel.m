//
//  OTCFilterModel.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCFilterModel.h"

@implementation OTCFilterModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.orderByClause = @"";
        self.countrys = @[];
        self.payModes = @[];
        self.highAmount = @"";
        self.lowAmount = @"";
        self.MaxLimitCount = @"";
        self.minLimitCount = @"";
    }
    return self;
}

@end
