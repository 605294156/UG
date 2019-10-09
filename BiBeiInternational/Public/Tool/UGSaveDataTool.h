//
//  UGSaveDataTool.h
//  BiBeiInternational
//
//  Created by keniu on 2018/9/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGAcountModel.h"

@interface UGSaveDataTool : NSObject


/**
 保存UG钱包信息
 @return 保存是否成功
 */
+ (BOOL)saveAccount:(UGAcountModel *)account;


/**
 更新某个UG钱包的信息

 @param account UG钱包信息
 */
+ (BOOL)updateAccount:(UGAcountModel *)account;



/**
 删除本地保存的UG钱包

 @param account UG钱包
 */
+ (void)deleteAccount:(UGAcountModel *)account;



/**
 获取存储的所有UG钱包

 @return UG钱包列表
 */
+ (NSArray <UGAcountModel *>*)getSaveAllAccount;

/**
 按条件获取存储的UG钱包
 
 @return UG钱包model
 */
+ (UGAcountModel *)getAccountWith:(NSString *)privateKey;


@end
