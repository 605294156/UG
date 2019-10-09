//
//  UGBaseRequest.m
//  BiBeiInternational
//
//  Created by keniu on 2018/9/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//


#import "UGBaseRequest.h"
#import "AFNetworking.h"
#import "UGLoginApi.h"
#import "AppDelegate+Bugly.h"

@interface UGBaseRequest ()

@property (nonatomic, strong) NSMutableDictionary *arguments;

@end

@implementation UGBaseRequest

- (NSMutableDictionary *)arguments {
    if (!_arguments) {
        _arguments = [[NSMutableDictionary alloc] init];
        NSString *userId = [UGManager shareInstance].hostInfo.ID;
        [_arguments setObject:userId.length > 0 ? userId : @""  forKey:@"id"];
        //版本号
        [_arguments setObject:APP_VERSION forKey:@"version"];
        //平台  0:安卓 1:IOS
        [_arguments setObject:@"1" forKey:@"platform"];
        [_arguments setObject:@"2" forKey:@"interfaceVersion"];
        NSString *iphoneType = [UG_MethodsTool iphoneType];
        [_arguments setObject: ! UG_CheckStrIsEmpty(iphoneType) ? iphoneType : @"" forKey:@"phoneModel"];
    }
    return _arguments;
}

- (id)requestArgument {
    // 这里添加公共参数
    return self.arguments;
}

///  Request serializer type.
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

///  Response serializer type. See also `responseObject`.
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

/**
 *普通请求  10s
 *上传图片请求 30s
 *涉及资金请求 60s
 *列表类请求 60s
 **/
- (NSTimeInterval)requestTimeoutInterval {
    return 10.0;
}

- (void)ug_startWithCompletionBlock:(UGRequestCompletionBlock)completionBlock {
    
    [super startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    
        NSLog(@" 请求详细数据： \n 请求路径：%@  \n  请求参数：%@  \n 请求头:%@ \n 返回参数：%@", request.originalRequest, [request.requestArgument mj_JSONString], request.requestHeaderFieldValueDictionary, [request.responseObject mj_JSONString]);
        
        NSDictionary *responseObject = [self.class convertResponseObjectToDict:request];
        if (responseObject) {
            NSNumber *errnoNumber = responseObject[@"code"];
            // 失败
            if (errnoNumber && [errnoNumber integerValue] != 0) {
                if (completionBlock) {
                    NSInteger number = [errnoNumber integerValue];
                    NSString *desc = responseObject[@"message"];
                    //登录失效
                    if (errnoNumber && [errnoNumber integerValue] == 4000) {
                        [[UGManager shareInstance] signout:^{
                            
                        }];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"登录失效" object:@"登录过期" userInfo:nil];
                    }else{
                        //错误信息上报   方便记录
                        [UG_MethodsTool reportErrorMessage:errnoNumber WithReson: desc WithUrl:request.originalRequest.URL];
                    }
                    //这里处理各种状态
                    UGApiError *error = [[UGApiError alloc] initWithErrorNumber:number desc:desc];
                    if (completionBlock) {
                        completionBlock(error, nil);
                    }
                }
            } else {
                
                if (completionBlock) {
                    completionBlock(nil, responseObject[@"data"]);
                }
            }
        } else {
            if (completionBlock) {
                UGApiError *apiError = [UGApiError responseError];
                [UG_MethodsTool reportErrorMessage:[NSNumber numberWithInteger:apiError.errorNumber] WithReson:apiError.desc WithUrl:request.originalRequest.URL];
                completionBlock(apiError, nil);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (completionBlock) {
            completionBlock([[UGApiError alloc] initWithBaseRequest:request], nil);
        }
    }];
}



-(NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    //登录后，后台返回。直接丢回给后台.
    NSString *access_auth_token = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
    [request setValue:access_auth_token ? access_auth_token : @"" forKey:@"access-auth-token"];
    //安全加密
    [request setValue:[UG_MethodsTool accessAuthUgcoinEncryption] forKey:@"access-auth-ugcoin"];
    //请求返回国际化
    NSString *language= LocalizationKey(@"responseLanguage");
    [request setValue:language forKey:@"Accept-Language"];
    return request;
}

#pragma mark - Public Method


/**
 request.responseObject 转换成 NSDict

 @param request YTKBaseRequest
 @return dict
 */
+ (NSDictionary *)convertResponseObjectToDict:(YTKBaseRequest *)request {
    NSDictionary *responseObject = nil;
    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
        responseObject = request.responseObject;
    } else if ([request.responseObject isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)request.responseObject;
        responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    return responseObject;
}


/**
 保存登录的access-auth-token

 @param request 登录接口的request
 */
+ (void)saveAccess_auth_token:(YTKBaseRequest *)request {
//    if ([request isKindOfClass:[UGLoginApi class]]) {
        NSHTTPURLResponse *httpResponse = request.response;
        //存储access-auth-token
        NSString *authToken = httpResponse.allHeaderFields[@"access-auth-token"];
        if (authToken.length > 0) {
            [NSUserDefaultUtil PutDefaults:@"access-auth-token" Value:authToken];
        }
        //存储x-auth-token
//        NSString *tokenstring= httpResponse.allHeaderFields[@"x-auth-token"];
//        if (tokenstring.length > 0) {
//            NSString *x_auth_tokenKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
//            [NSUserDefaultUtil PutDefaults:x_auth_tokenKey Value:tokenstring];
//        }
//    }
}


@end



@implementation UGResponseModel


@end
