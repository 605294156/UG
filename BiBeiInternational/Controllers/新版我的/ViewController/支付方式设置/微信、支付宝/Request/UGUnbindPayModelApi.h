//
//  UGUnbindPayModelApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/6/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGUnbindPayModelApi : UGBaseRequest
@property (nonatomic, assign) NSString *unbindWechat; //1 微信解绑传
@property (nonatomic, strong) NSString *unbindAliPay; //2 支付宝解绑传
@property (nonatomic, strong) NSString *unbindUnionPay; //3 云闪付解绑传
@end

NS_ASSUME_NONNULL_END
