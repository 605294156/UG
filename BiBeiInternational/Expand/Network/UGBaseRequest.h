//
//  UGBaseRequest.h
//  BiBeiInternational
//
//  Created by keniu on 2018/9/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "UGApiError.h"
#import "UGBaseModel.h"

@class UGResponseModel;

typedef void(^UGRequestCompletionBlock)(UGApiError * apiError, id object);

@interface UGBaseRequest : YTKRequest


/**
 只返回请求错误或成功的data

 @param completionBlock apiError or object
 */
- (void)ug_startWithCompletionBlock:(UGRequestCompletionBlock)completionBlock;

/**
 request.responseObject 转换成 NSDict
 
 @param request YTKBaseRequest
 @return dict
 */
+ (NSDictionary *)convertResponseObjectToDict:(YTKBaseRequest *)request;



/**
 保存登录的access-auth-token
 
 @param request 登录接口的request
 */
+ (void)saveAccess_auth_token:(YTKBaseRequest *)request;


@end



@interface UGResponseModel : UGBaseModel

@property (nonatomic, assign) id data;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;

@end
