//
//  UGAnewAppealApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/5/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAnewAppealApi : UGBaseRequest
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
