//
//  UGLoginRequest.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGLoginRequest.h"
#import "UGLoginApi.h"
#import "UGMineInfoApi.h"
#import <objc/runtime.h>
#import "UGUsernameLoginApi.h"

static const void *LoginBlockKey = &LoginBlockKey;//发送消息回调

@interface UGLoginRequest ()<YTKChainRequestDelegate>

@property (nonatomic, strong) YTKChainRequest *loginChainRequest;
@property (nonatomic, strong) UGHost *hostModel;
@property (nonatomic, strong) UGUserInfoModel *userInfoModel;

@end

@implementation UGLoginRequest


- (instancetype)init {
    self = [super init];
    if (self) {
        self.hostModel = nil;
        self.userInfoModel = nil;
        self.loginChainRequest = [YTKChainRequest new];
        self.loginChainRequest.delegate = self;
    }
    return self;
}

#pragma mark - Public Method

- (void)ug_startLoginWithCompletionBlock:(UGRequestCompletionBlock)completionBlock {
    objc_setAssociatedObject(self, LoginBlockKey, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //登录UG钱包
    [self sendLoginUGWalletRequest];
}


#pragma mark - Private Method

// 登录UG钱包
- (void)sendLoginUGWalletRequest {
    if (UG_CheckStrIsEmpty(self.country) && UG_CheckStrIsEmpty(self.areaCode)) {
        UGUsernameLoginApi *loginApi = [UGUsernameLoginApi new];
        loginApi.username = self.username;
        loginApi.password = self.password;
        __weak typeof(self.loginChainRequest) weakChainRequest = self.loginChainRequest;
        [weakChainRequest addRequest:loginApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            @weakify(self);
            [self responseObjectWithYTKBaseRequest:baseRequest complite:^(UGApiError *apiError, id object) {
                @strongify(self);
                if (!apiError) {
                    [UGLoginApi saveAccess_auth_token:baseRequest];
                    self.hostModel = [UGHost mj_objectWithKeyValues:object];
                    //获取用户信息
                    [self sendUserInfoRequest];
                } else {
                    //有错误直接回调出去
                    [self requestCompliteWithApiError:apiError];
                }
            }];
        }];
        //开始请求
        [weakChainRequest start];
    }else{
        UGLoginApi *loginApi = [UGLoginApi new];
        loginApi.username = self.username;
        loginApi.password = self.password;
        loginApi.country = self.country;
        loginApi.areaCode = self.areaCode;
        
        __weak typeof(self.loginChainRequest) weakChainRequest = self.loginChainRequest;
        [weakChainRequest addRequest:loginApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            @weakify(self);
            [self responseObjectWithYTKBaseRequest:baseRequest complite:^(UGApiError *apiError, id object) {
                @strongify(self);
                if (!apiError) {
                    [UGLoginApi saveAccess_auth_token:baseRequest];
                    self.hostModel = [UGHost mj_objectWithKeyValues:object];
                    //获取用户信息
                    [self sendUserInfoRequest];
                } else {
                    //有错误直接回调出去
                    [self requestCompliteWithApiError:apiError];
                }
            }];
        }];
        //开始请求
        [weakChainRequest start];
    }
}

//拉取个人信息
- (void)sendUserInfoRequest  {
    
    UGMineInfoApi *mineInfoApi = [UGMineInfoApi new];
    mineInfoApi.userId = self.hostModel.ID;
    
    __weak typeof(self.loginChainRequest) weakChainRequest = self.loginChainRequest;
    
    [weakChainRequest addRequest:mineInfoApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        @weakify(self);
         [self responseObjectWithYTKBaseRequest:baseRequest complite:^(UGApiError *apiError, id object) {
            UGRequestCompletionBlock completionBlock = objc_getAssociatedObject(self, LoginBlockKey);
            @strongify(self);
            if (!apiError) {
//                self.userInfoModel = [UGUserInfoModel mj_objectWithKeyValues:object];
                
                //修改：jIM接口的调用不影响 UG 钱包的登录与注册  在用到jIM 聊天时 重新判断jIM 的注册和登录是否成功
                
                self.userInfoModel = [UGUserInfoModel mj_objectWithKeyValues:object];
                self.hostModel.userInfoModel = self.userInfoModel;
                //保存账号、密码至keychian
                [keychianTool saveToKeychainWithUserName : self.username  withPassword:self.password country:self.country withareaCode:self.areaCode];
                [keychianTool saveUserName : self.username];
                completionBlock(nil, self.hostModel);
            } else {
                //调用退出登录接口
                [[UGManager shareInstance] signout:^{
                    
                }];
                //有错误直接回调出去
                [self requestCompliteWithApiError:apiError];
            }
        }];
    }];
}

// 对responseObject处理
- (void)responseObjectWithYTKBaseRequest:(YTKBaseRequest *)baseRequest complite:(UGRequestCompletionBlock)complite {
    NSDictionary *responseObject = [UGBaseRequest convertResponseObjectToDict:baseRequest];
    UGApiError *error = nil;
    if (responseObject) {
        NSNumber *errnoNumber = responseObject[@"code"];
        if (errnoNumber && [errnoNumber integerValue] != 0) {
            error = [[UGApiError alloc] initWithErrorNumber:[errnoNumber integerValue] desc:responseObject[@"message"]];
        }
    }
    if (complite) {
        complite(error,responseObject[@"data"]);
    }
}

// 回调出去
- (void)requestCompliteWithApiError:(UGApiError *)error {
    UGRequestCompletionBlock completionBlock = objc_getAssociatedObject(self, LoginBlockKey);
    if (completionBlock) {
        completionBlock (error, nil);
    }
}

#pragma mark - YTKChainRequestDelegate

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
//    NSLog(@"登录接口全部完成：%@",chainRequest);

}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
//    NSLog(@"登录接口报错：%@",request);
    [chainRequest stop];
    UGApiError *apiError = [[UGApiError alloc] initWithError:request.error];
    [self requestCompliteWithApiError:apiError];
}



@end
