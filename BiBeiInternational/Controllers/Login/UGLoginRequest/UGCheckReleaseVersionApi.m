//
//  UGCheckReleaseVersionApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCheckReleaseVersionApi.h"

@implementation UGCheckReleaseVersionApi
-(NSString *)requestUrl{
    return @"ug/appVersion/checkReleaseVersion";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    return argument;
}
@end

@implementation UGCheckReleaseVersionModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end
