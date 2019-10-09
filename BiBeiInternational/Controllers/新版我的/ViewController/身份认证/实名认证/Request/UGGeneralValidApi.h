//
//  UGGeneralVlidApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGGeneralValidApi : UGBaseRequest

@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *idCard;

@end

NS_ASSUME_NONNULL_END
