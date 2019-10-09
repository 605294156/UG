//
//  UGHighValidApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGHighValidApi.h"

@implementation UGHighValidApi

- (NSString *)requestUrl {
    return @"/ug/application/updateHighValid";
}


- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.inHandImg forKey:@"inHandImg"];
    [dict setObject:self.frontImg forKey:@"frontImg"];
    [dict setObject:self.behindImg forKey:@"behindImg"];
    return dict;
}

@end
