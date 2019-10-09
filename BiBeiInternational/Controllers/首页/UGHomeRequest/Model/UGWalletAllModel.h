//
//  UGWalletAllModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/25.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
/**
 UG钱包模型
 */
@interface UGWalletAllModel : UGBaseModel
@property(nonatomic,copy)NSString *ID;//UG钱包id
@property(nonatomic,copy)NSString *address;//UG钱包地址
@property(nonatomic,copy)NSString *balance;//余额
@property(nonatomic,copy)NSString *frozenBalance;//冻结jine
@property(nonatomic,copy)NSString *isLock;//是否冻结
@property(nonatomic,copy)NSString *memberId;//会员id
@property(nonatomic,copy)NSString *version;//版本号;
@property(nonatomic,copy)NSString *coinId;//币种;
@property(nonatomic,copy)NSString *name;//UG钱包名称
@property(nonatomic,copy)NSString *yesterdayIncome;//昨日总额;
@property(nonatomic,copy)NSString *totalIncome;//l累计总额;
@end
