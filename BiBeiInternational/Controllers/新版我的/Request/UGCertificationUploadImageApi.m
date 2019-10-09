//
//  UGCertificationUploadImageApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGCertificationUploadImageApi.h"

@implementation UGCertificationUploadImageApi


- (NSString *)requestUrl {
    return @"ug/common/upload/oss/image";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    if (self.saveInServer) {
        [dict setObject:@(YES) forKey:@"saveInServer"];
    }
    return dict;
}

@end
