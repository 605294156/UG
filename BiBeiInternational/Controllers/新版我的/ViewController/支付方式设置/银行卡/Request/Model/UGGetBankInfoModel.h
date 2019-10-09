//
//  UGGetBankInfoModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGGetBankInfoModel : UGBaseModel
@property(nonatomic, strong) NSString *bank; //银行卡名
@property(nonatomic, strong) NSString *cardNo; //银行卡号
@property(nonatomic, strong) NSString *province; //省
@property(nonatomic, strong) NSString *city;//城市
@end

NS_ASSUME_NONNULL_END
