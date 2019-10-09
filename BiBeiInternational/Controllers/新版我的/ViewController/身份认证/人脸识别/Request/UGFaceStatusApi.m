//
//  UGFaceStatusApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGFaceStatusApi.h"

@implementation UGFaceStatusApi
- (NSString *)requestUrl {
    return @"ug/application/auditFaceStatus";
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.bizToken)? self.bizToken : @"" forKey:@"bizToken"];
    return dict;
}


@end
