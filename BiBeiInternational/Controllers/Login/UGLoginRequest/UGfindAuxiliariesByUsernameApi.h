//
//  UGfindAuxiliariesByUsername.h
//  BiBeiInternational
//
//  Created by keniu on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGfindAuxiliariesByUsernameApi : UGBaseRequest
@property(nonatomic,copy)NSString *username;//用户名
@end

NS_ASSUME_NONNULL_END
