//
//  UGUpdateRealnameApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/7/31.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGUpdateRealnameApi : UGBaseRequest
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *idCard;
@end

NS_ASSUME_NONNULL_END
