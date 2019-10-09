//
//  UGApiError.h
//  BiBeiInternational
//
//  Created by keniu on 2018/9/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTKBaseRequest;

@interface UGApiError : NSObject

@property (nonatomic, assign) NSInteger errorNumber;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic , assign) BOOL isHttpResponseError;

- (instancetype)initWithErrorNumber:(NSInteger)errorNumber desc:(NSString *)desc;

- (instancetype)initWithError:(NSError *)error;

- (instancetype)initWithBaseRequest:(YTKBaseRequest *)requtest;

/**
 服务器返回数据解析异常
 */
+ (instancetype)responseError;

/**
 是否为 服务器返回数据解析异常
 */
- (BOOL)isResponseError;

/**
 是否为 断网
 */
- (BOOL)isNoNetworkError;

/**
 是否为 超时
 */
- (BOOL)isTimedOut;

@end
