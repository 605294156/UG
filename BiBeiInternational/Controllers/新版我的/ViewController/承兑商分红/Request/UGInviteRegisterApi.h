//
//  UGInviteRegisterApi.h
//  BiBeiInternational
//
//  Created by keniu on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGInviteRegisterApi : UGBaseRequest

@property (nonatomic, copy) NSString *memberId;//会员id
@property (nonatomic, copy) NSString *rate;

@end

NS_ASSUME_NONNULL_END
