//
//  UGCheckBankModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCheckBankModel : UGBaseModel
@property(nonatomic, strong) NSString *bankNameCn; //银行中文名
@property(nonatomic, strong) NSString *bankNameEn; //银行英文名
@property(nonatomic, strong) NSString *bankNameAcronym; //名称缩写
@property(nonatomic, strong) NSString *bankId;
@property(nonatomic, strong) NSString *sort; //1 热门银行
@end

NS_ASSUME_NONNULL_END
