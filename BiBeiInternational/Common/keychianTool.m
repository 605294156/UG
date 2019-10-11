//
//  keychianTool.m
//  CoinWorld
//
//  Created by sunliang on 2018/4/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "keychianTool.h"

@implementation keychianTool
/** 获取设备唯一标识符
 */
+ (NSString*)readUserUUID{
    NSMutableDictionary *userPwd = (NSMutableDictionary *)[ToolUtil load:UUIDKey];
    NSString *uuid = [userPwd objectForKey:UUIDKey];
    if (uuid == nil) {
        NSMutableDictionary *keyChain = [NSMutableDictionary dictionary];
        [keyChain setObject:UGUUID forKey:UUIDKey];
        [ToolUtil save:UUIDKey data:keyChain];
        uuid = [keyChain objectForKey:UUIDKey];
    }
    return uuid;
}
/** 保存用户账号和密码到钥匙串中
 */
+(void)saveToKeychainWithUserName:(NSString*)UserName withPassword:(NSString*)password country:(NSString*)country withareaCode:(NSString*)areacode{
    NSMutableDictionary *keyChain = [NSMutableDictionary dictionary];
//    [keyChain setObject:[NSString stringWithFormat:@"%@%@",UserName,password] forKey:USENAMEPASSWORD];
    
    [keyChain setObject:UserName forKey:@"UGUserName"];
    [keyChain setObject:password forKey:@"UGPassword"];
    [keyChain setObject:country forKey:@"UGCountry"];
    [keyChain setObject:areacode forKey:@"UGAreaCode"];

    [ToolUtil save:USENAMEPASSWORD data:keyChain];
    
}
///** 获取钥匙串中保存的账号密码
// */
//+(NSString*)getUserNameAndPasswordFromKeychain{
//    NSMutableDictionary *userPwd = (NSMutableDictionary *)[ToolUtil load:USENAMEPASSWORD];
//    NSString *UserNameAndPassword = [userPwd objectForKey:USENAMEPASSWORD];
//    
//    return UserNameAndPassword;
//}


/**
 获取保存的账号和密码
 
 @param completionBlock 账号和密码
 */
+ (void)getUserNameAndPasswordFromKeychain:(void(^)(NSString *userName, NSString *password,NSString *country,NSString *areacode))completionBlock {
    NSMutableDictionary *userPwd = (NSMutableDictionary *)[ToolUtil load:USENAMEPASSWORD];
    NSString *name = userPwd[@"UGUserName"];
    NSString *pwd = userPwd[@"UGPassword"];
    NSString *country =userPwd[@"UGCountry"];
    NSString *areaCode =userPwd[@"UGAreaCode"];
    if (completionBlock) {
        completionBlock(name,pwd,country,areaCode);
    }
}

+(void)saveUserName:(NSString *)UserName{
    NSMutableDictionary *keyChain = [NSMutableDictionary dictionary];
    [keyChain setObject:UserName forKey:@"UGReUserName"];
    [ToolUtil save:ReUSENAMEPASSWORD data:keyChain];
}

+ (void)getUserName:(void(^)(NSString *userName))completionBlock {
    NSMutableDictionary *userPwd = (NSMutableDictionary *)[ToolUtil load:ReUSENAMEPASSWORD];
    NSString *name = userPwd[@"UGReUserName"];
    if (completionBlock) {
        completionBlock(name);
    }
}


@end
