//
//  UGSubmissionApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 提交委托
 */
@interface UGSubmissionApi : UGBaseRequest
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *direction;//买入、卖出
@property(nonatomic,copy)NSString *type;//市价 、限价
@end

NS_ASSUME_NONNULL_END
