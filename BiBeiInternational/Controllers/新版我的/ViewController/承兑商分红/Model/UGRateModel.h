//
//  UGRateModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGRateModel : UGBaseModel
@property (nonatomic,copy)NSString *masterRate;  //当前承兑商的分红比例
@property (nonatomic,strong)NSArray *slaveRate; // 他可以设置的分红比例
@end

@interface UGSlaveRateModel : UGBaseModel
@property (nonatomic,copy)NSString *nextRate;
@property (nonatomic,copy)NSString *myDividend;
@property (nonatomic,assign)BOOL selected;
@end

NS_ASSUME_NONNULL_END
