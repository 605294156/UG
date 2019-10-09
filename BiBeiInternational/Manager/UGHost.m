//
//  UGHost.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGHost.h"

static NSString *UGHostKey = @"UGHostKey";

@implementation UGHost

/**
 保存登录的host信息，可能不包括userInfoModel
 */
- (void)saveHostInfoToUserDefaults {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];

    [NSUserDefaultUtil PutDefaults:@"UGKey" Value:data];
}

/**
 从UserDefaults清空保存的host信息
 */
+ (void)cleanHostInfoFromUserDefaults  {
    [NSUserDefaultUtil PutDefaults:@"UGKey" Value:@""];
}

/**
 从UserDefaults获取保存的UGHost
 @return 保存的用户信息
 */
+ (UGHost *)getHostInfoFromUserDefaults {
   id object = [NSUserDefaultUtil GetDefaults:@"UGKey"];
    if ([object isKindOfClass:[NSData class]]) {
        id nobject = [NSKeyedUnarchiver unarchiveObjectWithData:object];
        return nobject ;
    }
    return nil;
}



@end
