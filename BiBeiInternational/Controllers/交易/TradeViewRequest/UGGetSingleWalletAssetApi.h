//
//  UGGetSingleWalletAssetApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取单个UG钱包信息
 */
@interface UGGetSingleWalletAssetApi : UGBaseRequest
@property(nonatomic,copy)NSString *coin;//币种
@end

NS_ASSUME_NONNULL_END
