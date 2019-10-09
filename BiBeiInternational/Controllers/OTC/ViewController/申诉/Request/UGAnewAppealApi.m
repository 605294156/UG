//
//  UGAnewAppealApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/5/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAnewAppealApi.h"

@implementation UGAnewAppealApi
- (NSString *)requestUrl {
    return @"ug/otcv2/anewAppeal";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.orderSn forKey:@"orderSn"];
    [dict setObject:self.remark forKey:@"remark"];
    [dict setObject:self.mobile forKey:@"mobile"];
    [dict setObject:self.areaCode forKey:@"areaCode"];
    [dict setObject:self.country forKey:@"country"];
    [dict setObject:self.imgUrls.length > 0 ? self.imgUrls : @"" forKey:@"imgUrls"];
    [dict setObject:self.appealRealName forKey:@"appealRealName"];
    return dict;
}
@end
