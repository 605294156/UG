//
//  UGWechatPayModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGWechatPayModel : UGBaseModel

@property(nonatomic, copy) NSString *wechat;//微信号
@property(nonatomic, copy) NSString *qrWeCodeUrl;//收付款码

@end

NS_ASSUME_NONNULL_END
