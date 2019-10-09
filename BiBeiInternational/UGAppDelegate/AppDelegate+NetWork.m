//
//  AppDelegate+NetWork.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+NetWork.h"
#import <YTKNetwork/YTKNetwork.h>


#define UGFIRSTLOAD_NET            @"用来初始化网络环境"

@implementation AppDelegate (NetWork)


- (void)settingYTKNetworkConfig {
    
    //设置默认环境每次更新保本后都会去以当前版本来更新网络
    NSString *fistloadKey = [UGFIRSTLOAD_NET stringByAppendingString:APP_VERSION];
    if ([NSUSERDEFAULTS boolForKey:fistloadKey] == NO) {
        [UGURLConfig changeToReleaseState:YES];
        [self configBaseUrlCondition];
        [NSUSERDEFAULTS setBool:YES forKey:fistloadKey];
        [NSUSERDEFAULTS synchronize];
    }


    //统一设置网络请求的服务器
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = [UGURLConfig baseURL];
    
//    // 验证公钥和证书的其他信息
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // 允许自建证书
//    securityPolicy.allowInvalidCertificates = YES;
//    // 校验域名信息
//    securityPolicy.validatesDomainName      = YES;
//    // 获取证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"baidu" ofType:@"cer"];
//    //证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    // 添加服务器证书,单向验证;  可采用双证书 双向验证;
////    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
//    
//    [config setSecurityPolicy:securityPolicy];

    NSLog(@"------------------------%@",config.baseUrl);
}



/**初始化网络环境**/
- (void)configBaseUrlCondition {
#ifdef DEBUG
    [UGURLConfig changeToReleaseState:NO];
#else
    [UGURLConfig changeToReleaseState:YES];
#endif
}


@end
