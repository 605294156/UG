//
//  UGReBindingApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * 重新绑定谷歌验证器
 */
@interface UGReBindingApi : UGBaseRequest
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *code;
@end

NS_ASSUME_NONNULL_END
