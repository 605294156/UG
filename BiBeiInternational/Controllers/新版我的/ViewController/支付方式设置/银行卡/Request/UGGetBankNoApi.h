//
//  UGGetBankNoApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 银行卡号识别
 */
@interface UGGetBankNoApi : UGBaseRequest
- (id)initWithBankImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
