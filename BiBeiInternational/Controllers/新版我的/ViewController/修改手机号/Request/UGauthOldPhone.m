//
//  UGauthOldPhone.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGauthOldPhone.h"

@implementation UGauthOldPhone
-(NSString *)requestUrl{
    return @"ug/member/authOldPhone";
}

-(id)requestArgument{
    NSMutableDictionary *argument  = [super requestArgument];
    [argument removeObjectForKey:@"id"];
    [argument setObject:!UG_CheckStrIsEmpty(self.phone)?self.phone:@"" forKey:@"phone"];
    if(!self.isVerify){
        [argument setObject:!UG_CheckStrIsEmpty(self.code)?self.code:@"" forKey:@"code"];
    }
    return argument;
}
@end
