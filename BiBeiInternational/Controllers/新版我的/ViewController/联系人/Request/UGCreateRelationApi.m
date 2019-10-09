//
//  UGCreateRelationApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCreateRelationApi.h"

@implementation UGCreateRelationApi

- (NSString *)requestUrl {
    return @"ug/chat/createRelation";
}

- (id)requestArgument{
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.relationId)? self.relationId : @"" forKey:@"relationId"];
    return dict;
}

@end
