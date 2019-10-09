//
//  MentionCoinInfoModel.m
//  CoinWorld
//
//  Created by iDog on 2018/3/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MentionCoinInfoModel.h"

@implementation MentionCoinInfoModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"addresses":[AddressInfo class]};
}
@end
@implementation AddressInfo

@end
