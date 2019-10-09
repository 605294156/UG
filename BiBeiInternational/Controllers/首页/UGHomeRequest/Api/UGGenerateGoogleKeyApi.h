//
//  UGGenerateGoogleKeyApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
 获取谷歌验证码
 */
@interface UGGenerateGoogleKeyApi : UGBaseRequest
@property (nonatomic, copy) NSString *memberId;//会员id
@end
