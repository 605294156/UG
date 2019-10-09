//
//  UGOTCNewRelease.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGOTCNewRelease.h"

@implementation UGOTCNewRelease
- (NSString *)requestUrl {
    //    return @"ug/otc/release";
    return @"ug/otcv2/newRelease";
}

-(NSTimeInterval)requestTimeoutInterval{
    return 60;
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:!UG_CheckStrIsEmpty(self.orderSn)?self.orderSn:@"" forKey:@"orderSn"];
    [dict setObject:!UG_CheckStrIsEmpty(self.jyPassword)?self.jyPassword:@"" forKey:@"jyPassword"];
    [dict setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    [dict setObject:!UG_CheckStrIsEmpty(self.googleCode)?self.googleCode:@"" forKey:@"googleCode"];
    [dict setObject:!UG_CheckStrIsEmpty(self.validType)?self.validType:@"" forKey:@"validType"];
    return dict;
}
@end
