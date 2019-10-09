//
//  UGShelvesAdApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGShelvesAdApi : UGBaseRequest


/**
 是否是上架
 默认NO
 */
@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, strong) NSString *advertiseId;

@end

NS_ASSUME_NONNULL_END
