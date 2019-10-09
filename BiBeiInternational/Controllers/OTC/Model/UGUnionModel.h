//
//  UGUnionModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/8/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGUnionModel : UGBaseModel

@property(nonatomic, copy) NSString *unionNo;//云闪付号
@property(nonatomic, copy) NSString *qrUnionCodeUrl;//收款码

@end

NS_ASSUME_NONNULL_END
