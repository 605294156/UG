//
//  UGCheckBankModel.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGCheckBankModel.h"

@implementation UGCheckBankModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ @"bankId" : @"id" };
}
@end
