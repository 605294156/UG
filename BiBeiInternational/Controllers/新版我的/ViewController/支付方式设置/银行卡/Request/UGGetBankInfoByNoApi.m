//
//  UGGetBankInfoByNoApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetBankInfoByNoApi.h"

@implementation UGGetBankInfoByNoApi
- (NSString *)requestUrl {
    return @"ug/ocr/getBankInfoByNo";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    //    [dict setObject:self.branch forKey:@"branch"];
    [dict setObject: !UG_CheckStrIsEmpty(self.cardNo) ? self.cardNo : @"" forKey:@"cardNo"];
    
    return dict;
}

@end
