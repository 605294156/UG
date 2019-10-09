//
//  UGHost.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGHost : UGBaseModel

@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *district;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *memberLevel;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *promotionCode;
@property(nonatomic,copy)NSString *promotionPrefix;
@property(nonatomic,copy)NSString *ID;

/**
 用户信息：包含UG钱包、个人信息、认证信息、高级认证信息
 */
@property(nonatomic, strong) UGUserInfoModel *userInfoModel;


/**
 保存登录的host信息，可能不包括userInfoModel
 */
- (void)saveHostInfoToUserDefaults;



/**
 从UserDefaults清空保存的host信息
 */
+ (void)cleanHostInfoFromUserDefaults;


/**
 从UserDefaults获取保存的UGHost
 @return 保存的用户信息
 */
 + (UGHost *)getHostInfoFromUserDefaults;

@end

NS_ASSUME_NONNULL_END
