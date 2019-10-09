//
//  UGRelationDetailApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGRelationDetailApi.h"

@implementation UGRelationDetailApi

- (NSString *)requestUrl {
    return @"ug/chat/relationDetail";
}

- (id)requestArgument{
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.memberId)? self.memberId : @"" forKey:@"memberId"];
    [dict setObject:!UG_CheckStrIsEmpty(self.username)? self.username : @"" forKey:@"username"];
    return dict;
}

@end
