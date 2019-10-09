//
//  UGReviseAvatarApi.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReviseAvatarApi.h"

@implementation UGReviseAvatarApi

- (NSString *)requestUrl {
    return @"ug/member/update";
}

- (id)requestArgument {
    NSMutableDictionary *dict = [super requestArgument];
    [dict setValue:self.url ? : @"" forKey:@"avatar"];
//    NSString *str = [UGManager shareInstance].hostInfo.ID;
//    [dict setValue:str forKey:@"id"];
    return dict;
}

@end
