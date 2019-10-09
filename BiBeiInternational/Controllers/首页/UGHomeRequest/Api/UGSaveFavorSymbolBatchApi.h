//
//  UGSaveFavorSymbolBatchApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 添加多选币币自选
 */
@interface UGSaveFavorSymbolBatchApi : UGBaseRequest
@property (nonatomic,strong)NSMutableArray *symbolList;
@end
