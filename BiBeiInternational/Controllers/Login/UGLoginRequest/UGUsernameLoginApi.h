//
//  UGUsernameLoginApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/6/24.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGUsernameLoginApi : UGBaseRequest
@property(nonatomic,copy)NSString *username;//用户名
@property(nonatomic,copy)NSString *password;//密码
@end

NS_ASSUME_NONNULL_END
