#import <UIKit/UIKit.h>
#import "UGBaseModel.h"
#import "UGApplication.h"
#import "UGBusines.h"
#import "UGMember.h"
#import "UGWalletAllModel.h"
#import "UGMessageDictionary.h"


@interface UGUserInfoModel : UGBaseModel


@property (nonatomic, strong) UGApplication * application;
@property (nonatomic, strong) UGBusines * business;

/**
 实名认证
 */
@property (nonatomic, assign) BOOL hasRealnameValidation;

/**
 商家认证（暂未使用）
 */
@property (nonatomic, assign) BOOL hasBusinessValidation;
/**
 高级认证
 */
@property (nonatomic, assign) BOOL hasHighValidation;

/**
 绑定谷歌验证
 */
@property (nonatomic, assign) BOOL hasGoogleValidation;

 /**是否有交易密码设置*/
@property (nonatomic, assign) BOOL hasJypassword;


/**
 是否有银行卡绑定
 */
@property (nonatomic, assign) BOOL hasBankBinding;
/**
 是否有微信绑定
 */
@property (nonatomic, assign) BOOL hasWechatPay;
/**
 是否有支付宝绑定
 */
@property (nonatomic, assign) BOOL hasAliPay;

/**
 是否有云闪付
 */
@property (nonatomic, assign) BOOL hasUnionPay;

/**
 UG钱包列表,目前版本只有一个UG钱包
 */
@property (nonatomic, strong) NSArray <UGWalletAllModel *>* list;

/**
 用户详细信息
 */
@property (nonatomic, strong) UGMember * member;


/**
 j聊天需要给对方用户名拼接这个前缀
 */
@property (nonatomic, strong) NSString *chatPrefix;


/**
 客服j账号 带前缀的
 */
@property (nonatomic, strong) NSString *customerMemberAccount;

/**
 客服j头像
 */
@property (nonatomic, strong) NSString *customerAvatar;

/**
 客户j用户名 不带前缀
 */
@property (nonatomic, strong) NSString *customerUsername;

/**
 提示语
 */
@property (nonatomic, strong) NSArray <UGMessageDictionary *>* ugDictionaryList;

/**
 是否绑定手机号  0：未绑定  1：绑定
 */
@property (nonatomic, assign) BOOL bindMobilePhone;

/**
 是否备份了助记词  0未绑定 1绑定
 */
@property (nonatomic, assign) BOOL bindAuxiliaries;

@end
