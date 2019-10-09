//
//  UGOTCReleaseApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCReleaseApi : UGBaseRequest

@property(nonatomic, strong) NSString *orderSn;
@property(nonatomic, strong) NSString *jyPassword;
@property(nonatomic, strong) NSString  *googleCode;

@end

NS_ASSUME_NONNULL_END
