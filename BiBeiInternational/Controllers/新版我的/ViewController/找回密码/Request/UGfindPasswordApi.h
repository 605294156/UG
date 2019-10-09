//
//  UGfindPasswordApi.h
//  BiBeiInternational
//
//  Created by keniu on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGfindPasswordApi : UGBaseRequest
@property (nonatomic, copy) NSString *username;//用户名
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *auxiliaries;//新密码
@end

NS_ASSUME_NONNULL_END
