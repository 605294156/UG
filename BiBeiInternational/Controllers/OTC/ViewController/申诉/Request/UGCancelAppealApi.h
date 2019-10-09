//
//  UGCancelAppealApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/5/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCancelAppealApi : UGBaseRequest
@property(nonatomic, strong) NSString *orderSn;
@end

NS_ASSUME_NONNULL_END
