//
//  UGbindingGoogleApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 绑定谷歌验证码
 */
@interface UGbindingGoogleApi : UGBaseRequest
@property (nonatomic, copy) NSString *memberId;//会员id
@property (nonatomic, copy) NSString *code;//谷歌验证码
@end
