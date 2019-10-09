//
//  UGBaseModel.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseModel.h"

@implementation UGBaseModel

MJExtensionCodingImplementation


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ @"ID" : @"id" };
}




@end
