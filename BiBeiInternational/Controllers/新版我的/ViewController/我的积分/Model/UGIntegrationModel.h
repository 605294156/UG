//
//  UGIntegrationModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGIntegrationModel : UGBaseModel
@property (nonatomic, copy) NSString *createTime;  // 创建时间
@property (nonatomic, copy) NSString *responseScore;  //积分  加多少或减多少
@property (nonatomic, copy) NSString *type;  //1 超时取消订单 2 手工取消订单 3 完成订单 4充值赠送
@property (nonatomic, copy) NSString *remark;  //
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *ID;  //
@property (nonatomic, copy) NSString *updateTime;  //
@property (nonatomic, copy) NSString *optUser;  //
@property (nonatomic, copy) NSString *username;  //
@property (nonatomic, copy) NSString *orderSn;  //
@property (nonatomic, copy) NSString *memberId;  //

-(NSString *)returnStatus;
@end

NS_ASSUME_NONNULL_END
