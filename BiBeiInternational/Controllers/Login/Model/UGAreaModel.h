//
//  UGAreaModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAreaModel : UGBaseModel
@property(nonatomic,copy)NSString *zhName;//国家
@property(nonatomic,copy)NSString *areaCode;//区号
@property(nonatomic,copy)NSString *language;//语言
@property(nonatomic,copy)NSString *enName;//英文国家名
@property(nonatomic,copy)NSString *localCurrency;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *status;

@end

NS_ASSUME_NONNULL_END
