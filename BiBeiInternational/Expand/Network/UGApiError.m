//
//  UGApiError.m
//  BiBeiInternational
//
//  Created by keniu on 2018/9/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//


#import "UGApiError.h"
#import "YTKNetwork.h"

#define UGApiErrorDefaultMessage     @"服务器异常，技术小哥正在全力修复！" // 服务器异常
#define UGNetworkErrorDefaultMessage @"网络异常，连接不到服务器" // 网络异常
#define UGNetworkTimeOutDefaultMessage  @"请求超时，请稍候重试" // 超时
#define UGNoNetworkDefaultMessage    @"无网络连接，请检查您的网络" // 断网

#define UGApiErrorResponseError NSURLErrorUnknown // 服务器返回数据解析异常
#define UGApiErrorNoNetWork NSURLErrorNetworkConnectionLost // 断网


@implementation UGApiError

- (instancetype)initWithErrorNumber:(NSInteger)errorNumber desc:(NSString *)desc {
    if (self = [super init]) {
        _errorNumber = errorNumber;
        _desc = [desc copy];
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error {
    return [self initWithErrorNumber:error.code desc:error.localizedDescription];
}

- (instancetype)initWithBaseRequest:(YTKBaseRequest *)request {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSString *desc = nil;
    NSInteger errorNumber = UGApiErrorResponseError;
    NSDictionary *responseDictionary = nil;
    id responseObject = request.responseObject;
    if ([responseObject isKindOfClass:[NSDictionary class]]) { // json 格式
        responseDictionary = (NSDictionary *)responseObject;
    } else if ([responseObject isKindOfClass:[NSData class]]) { // http 格式
        NSData *data = (NSData *)responseObject;
        NSError *errr = nil;
        responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errr];
    }
    if (responseDictionary) {
        desc = responseDictionary[@"desc"];
        if (responseDictionary[@"errno"]
            && [responseDictionary[@"errno"] isKindOfClass:[NSNumber class]]) {
            errorNumber = [(NSNumber *)responseDictionary[@"errno"] integerValue];
        }
        if (errorNumber >= 500) {
            desc = UGApiErrorDefaultMessage;
            [UG_MethodsTool reportErrorMessage:[NSNumber numberWithInteger:errorNumber] WithReson:desc WithUrl:request.originalRequest.URL];
        }
    } else {
        
        //标记为响应错误
        self.isHttpResponseError = YES;
        
        NSError *error = request.error;
        if (error) {
            switch (error.code) {
                case NSURLErrorNotConnectedToInternet:
                case NSURLErrorNetworkConnectionLost:
                    desc = UGNoNetworkDefaultMessage;
                    errorNumber = UGApiErrorNoNetWork;
                    break;
                case NSURLErrorTimedOut:
                    desc = UGNetworkTimeOutDefaultMessage;
                    errorNumber = NSURLErrorTimedOut;
                    //超时上报
                    [UG_MethodsTool reportErrorMessage:[NSNumber numberWithInteger:errorNumber] WithReson:desc WithUrl:request.originalRequest.URL];
                    break;
                default:
                {
                    desc = UGNetworkErrorDefaultMessage;
#ifdef DEBUG
                    desc = [NSString stringWithFormat:@"%@(%zd)", UGNetworkErrorDefaultMessage, error.code];
#endif
                    errorNumber = error.code;
                }
                    break;
            }
        } else {
            desc = UGNoNetworkDefaultMessage;
            errorNumber = UGApiErrorNoNetWork;
        }
    }
    
    self.errorNumber = errorNumber;
    self.desc = desc ?: UGApiErrorDefaultMessage;
    
    return self;
}

/**
 服务器返回数据解析异常
 */
+ (instancetype)responseError {
    return [[self alloc] initWithErrorNumber:UGApiErrorResponseError desc:UGApiErrorDefaultMessage];
}

/**
 是否为 服务器返回数据解析异常
 */
- (BOOL)isResponseError {
    return self.errorNumber == UGApiErrorResponseError;
}
/**
 是否为 断网
 */
- (BOOL)isNoNetworkError {
    return self.errorNumber == UGApiErrorNoNetWork;
}

/**
 是否为 超时
 */
- (BOOL)isTimedOut {
    return self.errorNumber == NSURLErrorTimedOut;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"code: %zd, des:%@", self.errorNumber, self.desc];
}
@end
