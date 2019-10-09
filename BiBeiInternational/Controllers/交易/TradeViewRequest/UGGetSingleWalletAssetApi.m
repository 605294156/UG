//
//  UGGetSingleWalletAssetApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGGetSingleWalletAssetApi.h"

@implementation UGGetSingleWalletAssetApi
-(NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@",@"uc/asset/wallet/",!UG_CheckStrIsEmpty(self.coin)?self.coin:@""];
}
@end
