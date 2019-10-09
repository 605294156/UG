//
//  UGSaveDataTool.m
//  BiBeiInternational
//
//  Created by keniu on 2018/9/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGSaveDataTool.h"
#import "AESCrypt.h"

//加密的key，切勿修改。修改后会导致老版本升级后无法读取数据
static NSString *PasswordKey = @"gfnzZfiCqnF)=uvDCPJYkEfTwFpMaNDCgM^4jbtBGxuGX[CjJ,s8;uv9UgRbMVs?";

@implementation UGSaveDataTool

#pragma mark - Public Method

+ (BOOL)saveAccount:(UGAcountModel *)account {
    
    //保存路径存在才执行
    if ([self walletPath]) {

        //先判断这个UG钱包信息是否已经保存
        if ([self accountIsExist:account]) {
            
            //已经保存则调用updateAccount
         return  [self updateAccount:account];
            
        } else { //直接保存到本地
            
            //读取上次保存的数据
            id data = [self decryptAccountList:[NSKeyedUnarchiver unarchiveObjectWithFile:[self walletPath]]];

            NSMutableArray *accountList;
            if (data) {
                accountList = [[NSMutableArray alloc] initWithArray:data];
            } else {
                accountList = [NSMutableArray new];
            }
            //加入本次需要保存的数据
            [accountList addObject:[account mj_JSONString]];
            //写入本地
           return  [self writeToWalletPath:accountList];
        }
    }
    return NO;
}

/**
 更新某个UG钱包的信息
 
 @param account UG钱包信息
 */
+ (BOOL)updateAccount:(UGAcountModel *)account {
    if ([self walletPath]) {
        id data = [self decryptAccountList:[NSKeyedUnarchiver unarchiveObjectWithFile:[self walletPath]] ];
        NSMutableArray *accountList = [[NSMutableArray alloc] initWithArray:data];
        __block NSUInteger index = NSNotFound;
        [accountList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            UGAcountModel *model = [UGAcountModel mj_objectWithKeyValues:dict];
            if ([model.privateKey isEqualToString:account.privateKey]) {
                index = idx;
                *stop = YES;
            }
        }];
        if (index != NSNotFound) {
            [accountList replaceObjectAtIndex:index withObject:[account mj_JSONString]];
           BOOL sucess = [self writeToWalletPath:accountList];
            return sucess;
        }
    }
    return YES;
}




/**
 删除本地保存的UG钱包
 
 @param account UG钱包
 */
+ (void)deleteAccount:(UGAcountModel *)account {
    if ([self walletPath]) {
        if ([self accountIsExist:account]) {//本地数据找到了改UG钱包
            id data = [self decryptAccountList:[NSKeyedUnarchiver unarchiveObjectWithFile:[self walletPath]]];
                       
            NSMutableArray *accountList = [[NSMutableArray alloc] initWithArray:data];
            
            [accountList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                    if (dict) {
                        UGAcountModel *tempAccount = [UGAcountModel mj_objectWithKeyValues:dict];
                        //私钥一样
                        if ([tempAccount.privateKey isEqualToString:account.privateKey]) {
                            //移除该UG钱包
                            [accountList removeObjectAtIndex:idx];
                            //更新数据后写入本地
                            BOOL sucess = [self writeToWalletPath:accountList];
                            if (sucess) {
                                NSLog(@"删除该钱包成功：%@",[account mj_JSONString]);
                            } else {
                                NSLog(@"删除该钱包失败：%@",[account mj_JSONString]);
                            }
                            *stop = YES;
                        }
                    }
                }

            }];
        } else {
            NSLog(@"该钱包数据还未存入本地!");
        }
    }
}


/**
 获取存储的所有UG钱包
 
 @return UG钱包列表
 */
+ (NSArray <UGAcountModel *>*)getSaveAllAccount {
    if ([self walletPath]) {
        id data = [self decryptAccountList:[NSKeyedUnarchiver unarchiveObjectWithFile:[self walletPath]]];
        NSMutableArray <UGAcountModel*>*accountList = [[NSMutableArray alloc] initWithArray:[UGAcountModel mj_objectArrayWithKeyValuesArray:data]];
        return accountList;
    }
    return [NSArray new];
}


#pragma mark - Private Method

/**
 加密UG钱包列表
 
 @param list 需要加密的列表
 @return 加密后的字符串
 */
+ (NSString *)encryptAccountList:(NSArray *)list {
    return [AESCrypt encrypt:[list mj_JSONString] password:PasswordKey];
}


/**
 解密UG钱包列表
 
 @param list 需要解密的列表
 @return 解密后的字符串
 */
+ (NSArray *)decryptAccountList:(NSArray *)list {
    NSString *json = [AESCrypt decrypt:[list mj_JSONString] password:PasswordKey];
    if (json) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        return array;
    }
    return [NSArray new];
}


/**
 判断当前UG钱包信息是否已经存储
 
 @param account UG钱包信息
 @return 是否已经保存
 */
+ (BOOL)accountIsExist:(UGAcountModel *)account {
    id data = [self decryptAccountList:[NSKeyedUnarchiver unarchiveObjectWithFile:[self walletPath]]];
    if (!data) {
        return NO;
    }
    NSMutableArray *accountList = [[NSMutableArray alloc] initWithArray:data];
    for (NSString *str in accountList) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        UGAcountModel *tempAccount = [UGAcountModel mj_objectWithKeyValues:dict];
        //私钥一样，则说明该UG钱包已保存过
        if ([tempAccount.privateKey isEqualToString:account.privateKey]) {
            return YES;
        }
    }
    return NO;
}


+ (BOOL)writeToWalletPath:(NSArray*)accountList {
    //重写写入覆盖上次数据
    BOOL sucess = [NSKeyedArchiver archiveRootObject:[self encryptAccountList:accountList] toFile:[self walletPath]];
    if (sucess) {
        NSLog(@"写入数据成功");
    } else {
        NSLog(@"写入数据失败");
    }
    return sucess;
}

/**
 按条件获取存储的UG钱包
 
 @return UG钱包model
 */
+ (UGAcountModel *)getAccountWith:(NSString *)privateKey
{
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self walletPath]];
    if (!data) {
        return nil;
    }
    UGAcountModel *model = nil;
    NSMutableArray <UGAcountModel*>*accountList = [[NSMutableArray alloc] initWithArray:data];
    for (UGAcountModel *tempAccount in accountList) {
        //私钥一样，则说明该UG钱包已保存过
        if ([tempAccount.privateKey isEqualToString:privateKey]) {
            model = tempAccount;
        }
    }
    return model;
}

/**
 文件保存路径
 */
+ (NSString *)walletPath {
    
    NSString *walletPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Wallet"];
    //文件不存在则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:walletPath]) {
        //创建文件夹
        BOOL sucess = [[NSFileManager defaultManager] createDirectoryAtPath:walletPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (sucess) {
            NSLog(@"创建文件夹成功");
        } else {
            NSLog(@"创建文件夹失败");
        }
    }
    NSLog(@"沙盒地址：%@",[walletPath stringByAppendingPathComponent:@"walletData"]);
    return [walletPath stringByAppendingPathComponent:@"walletData"];
}

@end
