//
//  UGOTCAppealApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/9.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCAppealApi : UGBaseRequest

@property(nonatomic, strong) NSString *orderSn;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, strong) NSString *appealRealName;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *areaCode;
@property(nonatomic, strong) NSString *country;
/**
 图片URL用,拼接
 */
@property(nonatomic, strong) NSString *imgUrls;

@end

NS_ASSUME_NONNULL_END
