//
//  UGManager.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGManager.h"
#import "UGMineInfoApi.h"
#import "UGSingoutApi.h"
#import "UGLoginRequest.h"
#import "UGQYSDKManager.h"
#import "UGOrderWaitingDealListApi.h"

@interface UGManager ()

@end

@implementation UGManager

static UGManager* instance = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance ;
}

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [UGManager shareInstance];
}

-(id) copyWithZone:(struct _NSZone *)zone {
    return [UGManager shareInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id object = [UGHost getHostInfoFromUserDefaults];
        if (object != nil) {
            self.hostInfo = object;
        }
    }
    return self;
}


#pragma mark - Public Method

/**
 退出登录
 
 @param completionBlock 退出成功回调
 */
- (void)signout:(void(^)(void))completionBlock {
    //清除保存的用户信息
    [UGHost cleanHostInfoFromUserDefaults];
    
    //退出UG钱包登录
    NSString *token = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
    NSLog(@"token = %@",token);
    
    if (token.length > 0) {
        [[UGSingoutApi new] ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            
            NSLog(@"调用退出登录接口：%@", apiError ? apiError.desc : @"成功");
            
            [NSUserDefaultUtil PutDefaults:@"access-auth-token" Value:@""];
            if (completionBlock) {
                completionBlock();
            }
        }];
    } else {
        if (completionBlock) {
            completionBlock();
        }
    }
    
    //退出网易七鱼
    [[UGQYSDKManager shareInstance] logoutQYSDK];
 
//    //退出jIM
//    [JMSGUser logout:^(id resultObject, NSError *error) {
//        //退出UG钱包登录
//        NSString *token = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
//        if (token.length > 0) {
//            [[UGSingoutApi new] ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
//                NSLog(@"调用退出登录接口：%@", apiError ? apiError.desc : @"成功");
//                [NSUserDefaultUtil PutDefaults:@"access-auth-token" Value:@""];
//                if (completionBlock) {
//                    completionBlock();
//                }
//            }];
//        } else {
//            if (completionBlock) {
//                completionBlock();
//            }
//        }
//    }];
}

/**
 登录接口 ：登录UG钱包 -> 拉取个人信息 -> 登录jIM
 
 @param userName 用户名即账号
 @param password 密码
 @param areacode 地区
 @param country 国家
 @param completionBlock 请求返回
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password country:(NSString *)country areaCode:(NSString *)areacode completionBlock:(UGRequestCompletionBlock)completionBlock {
    //UGLoginRequest ：登录UG钱包 -> 拉取个人信息 -> 登录jIM
    UGLoginRequest *loginRequest = [UGLoginRequest new];
    loginRequest.username = userName;
    loginRequest.password = password;
    loginRequest.country = country;
    loginRequest.areaCode = areacode;
    [loginRequest ug_startLoginWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            self.hostInfo = (UGHost *)object;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"登录成功刷新界面数据" object:nil];
        }
        if (completionBlock) {
            completionBlock(apiError, object);
        }
    }];
}


/**
 自动登录即指纹、人脸识别登录
 */
- (void)autoLoginCompletionBlock:(UGRequestCompletionBlock)completionBlock {
    
    [keychianTool getUserNameAndPasswordFromKeychain:^(NSString *userName, NSString *password,NSString *country,NSString *areacode) {
        
        [self loginWithUserName:userName password:password  country:country areaCode:areacode completionBlock:^(UGApiError *apiError, id object) {
            
            if (completionBlock) {
                completionBlock(apiError,object);
            }
        }];
    }];
}

/**
 更新保存的登录密码，修改登录密码后保存
 
 @param nPassword 新密码
 */
- (void)updatePasswordToSave:(NSString *)nPassword {
    
    //先取出来保存的再更新密码
    [keychianTool getUserNameAndPasswordFromKeychain:^(NSString *userName, NSString *password,NSString *country,NSString *areacode) {
        //保存用户、密码到keychian
        [keychianTool saveToKeychainWithUserName:userName withPassword:nPassword country:country withareaCode:areacode];
        
    }];
}


/**
 获取用户详细信息，成功后自定刷新hostInfo.userInfoModel的值
 @param completionBlock 请求返回
 */
- (void)sendGetUserInfoRequestCompletionBlock:(UGRequestCompletionBlock)completionBlock {
    UGMineInfoApi *mineInfoApi = [UGMineInfoApi new];
    mineInfoApi.userId = [UGManager shareInstance].hostInfo.ID;
    [mineInfoApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if (self.hostInfo) {
                self.hostInfo.userInfoModel = [UGUserInfoModel mj_objectWithKeyValues:object];
                //保存登录信息
                [self.hostInfo saveHostInfoToUserDefaults];
                //保存第三方配置
                [self saveKey];
            }
        }
        if (completionBlock) {
            completionBlock(apiError,object);
        }
    }];
}

/**
 * 保存第三方配置
 */
-(void)saveKey{
    for (UGMessageDictionary *item in [UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList){
        if ([item.dicKey isEqualToString: @"qykey"]) {// 七鱼
            NSDictionary *qykeyDic = [UG_MethodsTool dictWithJsonString:item.dicValue];
            NSString *qykeyValue = [qykeyDic objectForKey: @"ios"];
            if ( ! UG_CheckStrIsEmpty(qykeyValue)) {
                NSString *savekey = [NSUserDefaultUtil GetDefaults: @"qykey"];
                if ( ! [qykeyValue isEqualToString:savekey]) {
                    [NSUserDefaultUtil PutDefaults: @"qykey" Value: qykeyValue];
                }
            }
        }else if ( [item.dicKey isEqualToString: @"buglykey"] ) {// bugly
            NSDictionary *buglykeyDic = [UG_MethodsTool dictWithJsonString:item.dicValue];
            NSString *buglykeyValue = [buglykeyDic objectForKey: @"ios"];
            if ( ! UG_CheckStrIsEmpty(buglykeyValue)) {
                NSString *savekey = [NSUserDefaultUtil GetDefaults: @"buglykey"];
                if ( ! [buglykeyValue isEqualToString:savekey]) {
                    [NSUserDefaultUtil PutDefaults: @"buglykey" Value: buglykeyValue];
                }
            }
        }
    }
}

/**
 * 设置指纹登录状态
 */
-(void)hasTouchIDOrFaceIDVerifyValue:(NSString *)value{
    [NSUserDefaultUtil PutDefaults:@"hasSettingFaceID" Value:value];
}

/**  
 * 获取指纹登录状态
 */
-(BOOL)getTouchIDOrFaceIDVerifyValue{
    BOOL hasVerifyed = NO;
    id data = [NSUserDefaultUtil GetDefaults:@"hasSettingFaceID"];
    if ([data isKindOfClass:[NSString class]]  && [(NSString *)data isEqualToString:@"1"]) {
        hasVerifyed= YES;
    }
    return hasVerifyed;
}

-(UGCheckFaceIDOrTouchID)checkIsSupportFaceIDOrTouchID{
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 8.0, *)) {
        LAContext *LAContent = [[LAContext alloc] init];
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        if (authError) {
            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
            return UGCheckFail;
        }else
        {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (LAContent.biometryType) {
                        case LABiometryNone:
                        {
                             return UGNotSupportFaceIDOrTouchID;
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                             return UGSupportTouchID;
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            return UGSupportFaceID;
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    // Fallback on earlier versions
                    NSLog(@"iOS 11之前不需要判断 biometryType");
                    // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                    return UGSupportTouchID;
                }
                
            } else {
                return UGNotSupportFaceIDOrTouchID;
            }
        }
    }else{
        return UGNotSupportFaceIDOrTouchID;
    }
}


/**
 交易功能是否被限制
 
 @return 被限制还是未被限制
 */
- (BOOL)userTransactionDisable {
    if (![self hasLogged]) {return NO;}
    if ([self.hostInfo.userInfoModel.member.transactionStatus isEqualToString:@"0"]) {
        [[UIApplication sharedApplication].keyWindow ug_showToastWithToast:@"您的账号已被禁用交易，请联系客服处理。"];
        return YES;
    }
    return NO;
}


/**
 是否绑定了任何支付方式
 支付宝、微信、银行卡 、云闪付其中一种
 */
- (BOOL)hasBindingPayMode {
    UGUserInfoModel *infoModel = self.hostInfo.userInfoModel;
    if (infoModel.hasAliPay || infoModel.hasWechatPay || infoModel.hasBankBinding || infoModel.hasUnionPay) {
        return YES;
    }
    return NO;
}

/**
 获取高级认证状态 * 0：审核中  1:失败  2：成功
 */
- (NSString *)getHighValidationAuditStatus{
    UGUserInfoModel *infoModel = self.hostInfo.userInfoModel;
    NSString *stateStr = @"";
    if ([infoModel.application.auditStatus isEqualToString:@"0"]) {
        stateStr = @"审核中";
    }else if([infoModel.application.auditStatus isEqualToString:@"1"]){
        stateStr = @"失败";
    }else if([infoModel.application.auditStatus isEqualToString:@"2"]){
        stateStr = @"成功";
    }
    return stateStr;
}

/**
 是否绑定了谷歌验证器
 */
- (BOOL)hasBindingGoogleValidation {
    UGUserInfoModel *infoModel = self.hostInfo.userInfoModel;
    return infoModel.hasGoogleValidation;
}



/**
 查询是否登录
 
 */
- (BOOL)hasLogged {
    NSString *object = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
    if (object.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark-获取OTC待办事项
-(void)getOrderWaitingDealList:(void(^)(BOOL complete,NSMutableArray *object))completeHandle{
    UGOrderWaitingDealListApi *api = [UGOrderWaitingDealListApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        NSMutableArray *orderWaitingArr = [NSMutableArray new];
        if (object) {
            NSArray *dataArr = [UGOrderWaitingModel mj_objectArrayWithKeyValuesArray:object];
            [orderWaitingArr addObjectsFromArray:dataArr];
        }
        completeHandle(YES,orderWaitingArr);
    }];
}

#pragma mark - Setter Method

- (void)setHostInfo:(UGHost *)hostInfo {
    _hostInfo = hostInfo;
    //保存登录信息到UserDefaults
    [hostInfo saveHostInfoToUserDefaults];
}

@end
