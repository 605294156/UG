//
//  UGAppealModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/19.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAppealModel : UGBaseModel
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *associateId;//被申诉f方id
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *initiatorId;//申诉方id
@property (nonatomic,copy)NSString *isSuccess;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *adminId;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *mobile; //申诉电话
@property (nonatomic,copy)NSString *areaCode; //电话区号
@property (nonatomic,copy)NSString *country; //国家
@property (nonatomic,copy)NSString *adminRemark;
@property (nonatomic,copy)NSString *associateRealName;//被申诉方
@property (nonatomic,copy)NSString *associateUsername;
@property (nonatomic,copy)NSString *initiatorRealName;//申诉方
@property (nonatomic,copy)NSString *initiatorUsername;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *imgUrls;
@end

NS_ASSUME_NONNULL_END
