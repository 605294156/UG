//
//  UGHighValidApi.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGHighValidApi : UGBaseRequest

/**
 手持身份证件照 URLString
 */
@property (nonatomic, strong) NSString *inHandImg;
/**
 身份证正面照 URLString
 */
@property (nonatomic, strong) NSString *frontImg;
/**
 身份证背面照  URLString
 */
@property (nonatomic, strong) NSString *behindImg;


@end

NS_ASSUME_NONNULL_END
