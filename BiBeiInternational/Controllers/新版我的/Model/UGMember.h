#import <UIKit/UIKit.h>
#import "UGBaseModel.h"

@interface UGMember : UGBaseModel

@property (nonatomic, copy) NSString * aliNo;
@property (nonatomic, copy) NSString * appealSuccessTimes;
@property (nonatomic, copy) NSString * appealTimes;
@property (nonatomic, copy) NSString * applicationTime;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * bank;
@property (nonatomic, copy) NSString * branch;
@property (nonatomic, copy) NSString * cardNo;
@property (nonatomic, copy) NSString * bankProvince;
@property (nonatomic, copy) NSString * bankCity;
@property (nonatomic, copy) NSString * certifiedBusinessApplyTime;
@property (nonatomic, copy) NSString * certifiedBusinessCheckTime;
@property (nonatomic, copy) NSString * certifiedBusinessStatus;
@property (nonatomic, copy) NSString * channelId;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * country;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * firstLevel;
@property (nonatomic, copy) NSString * googleDate;
@property (nonatomic, copy) NSString * googleKey;
@property (nonatomic, copy) NSString * googleState;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * idNumber;
@property (nonatomic, copy) NSString * inviterId;
@property (nonatomic, copy) NSString * isChannel;
@property (nonatomic, copy) NSString * jyPassword;
@property (nonatomic, copy) NSString * lastLoginTime;
@property (nonatomic, copy) NSString * local;
@property (nonatomic, copy) NSString * loginCount;
@property (nonatomic, copy) NSString * loginLock;
@property (nonatomic, copy) NSString * margin;
@property (nonatomic, copy) NSString * memberLevel;
@property (nonatomic, copy) NSString * mobilePhone;
@property (nonatomic, copy) NSString * areaCode;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * promotionCode;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * publishAdvertise;
@property (nonatomic, copy) NSString * qrCodeUrl;
@property (nonatomic, copy) NSString * qrWeCodeUrl;
@property (nonatomic, copy) NSString * realName;
@property (nonatomic, copy) NSString * realNameStatus;
@property (nonatomic, copy) NSString * registrationTime;
@property (nonatomic, copy) NSString * salt;
@property (nonatomic, copy) NSString * secondLevel;
@property (nonatomic, assign) BOOL signInAbility;
@property(nonatomic,copy)NSString *registername;
@property (nonatomic, copy) NSString * qrUnionCodeUrl;
@property (nonatomic, copy) NSString * unionPay;


@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * thirdLevel;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * tokenExpireTime;

/**
  操作被禁用
 0  没被禁用
 1 已被禁用
 */
@property (nonatomic, copy) NSString * forbiddenOpt;

/**
 是否没有被禁用
 1  没被禁用
 0 已被禁用
 */
@property (nonatomic, copy) NSString * transactionStatus;

@property (nonatomic, copy) NSString * transactionTime;
@property (nonatomic, copy) NSString * transactions;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * wechat;

/**
 jIM账号
 */
@property (nonatomic, copy) NSString *messageAccount;

/**
 jIM密码
 */
@property (nonatomic, copy) NSString *messagePassword;

/**
 cardVip  0 非承兑商  1 承兑商
 */
@property (nonatomic, copy) NSString * cardVip;

@end
