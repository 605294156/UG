//
//  UGGetBankInfoByNoApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGGetBankInfoByNoApi : UGBaseRequest
@property(nonatomic, strong) NSString *cardNo;//银行卡号
@end

NS_ASSUME_NONNULL_END
