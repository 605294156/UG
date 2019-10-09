//
//  UGCheckMemberOtcOrderApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/9/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCheckMemberOtcOrderApi.h"

@implementation UGCheckMemberOtcOrderApi
- (NSString *)requestUrl {
    return @"ug/otcv2/checkMemberOtcOrder";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    return dict;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}
@end
