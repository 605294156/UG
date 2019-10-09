//
//  keychianTool.h
//  CoinWorld
//
//  Created by sunliang on 2018/4/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface keychianTool : NSObject

/** 获取设备唯一标识符
 */
+ (NSString*)readUserUUID;

//保存用户账号和密码到钥匙串中
+(void)saveToKeychainWithUserName:(NSString*)UserName withPassword:(NSString*)password country:(NSString*)country withareaCode:(NSString*)areacode;

///** 获取钥匙串中保存的账号密码
// */
//+(NSString*)getUserNameAndPasswordFromKeychain;
//


/**
 获取保存的账号和密码

 @param completionBlock 账号和密码
 */
+ (void)getUserNameAndPasswordFromKeychain:(void(^)(NSString *userName, NSString *password,NSString *country,NSString *areacode))completionBlock;

+(void)saveUserName:(NSString *)UserName;

+ (void)getUserName:(void(^)(NSString *userName))completionBlock;

@end
