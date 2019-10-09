//
//  UGRateModel.m
//  BiBeiInternational
//
//  Created by conew on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGRateModel.h"

@implementation UGRateModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"slaveRate":[UGSlaveRateModel class]};
}
@end

@implementation UGSlaveRateModel

@end
