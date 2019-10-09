//
//  UGNotifyModel.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGNotifyModel.h"
#import "UGRemotemessageHandle.h"

@implementation UGNotifyModel


@end

@implementation UGNotifySuperModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rows = [NSArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"rows":[UGNotifyModel class]};
}

@end
