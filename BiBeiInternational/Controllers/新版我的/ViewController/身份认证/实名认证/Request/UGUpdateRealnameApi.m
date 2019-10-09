//
//  UGUpdateRealnameApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/7/31.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGUpdateRealnameApi.h"

@implementation UGUpdateRealnameApi
- (NSString *)requestUrl {
    return @"/ug/application/updateRealname";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setObject:self.realname forKey:@"realname"];
    [dict setObject:self.idCard forKey:@"idCard"];
    return dict;
}
@end
