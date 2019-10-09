//
//  BaseNetManager.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseNetManager.h"


//定义一个变量
static BaseNetManager *netManager = nil;

@interface BaseNetManager ()<NSURLSessionDelegate>

@end

@implementation BaseNetManager


+ (instancetype)shareNetManager
{
    @synchronized(self) {
        if (!netManager) {
            netManager = [[BaseNetManager alloc] init];
        }
        return netManager;
    }
}

+(void)ylRequestWithGET:(NSString *)urlString parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
   
    NSMutableDictionary *para = [parameter mutableCopy];
    NSString *urlStr = urlStr = [NSString stringWithFormat:@"%@%@",[UGURLConfig baseURL],urlString];
    NSLog(@"接口：%@ %@",urlStr,para);
    [BaseNetManager requestWithPost:urlStr parameters:para successBlock:^(id resultObject, int isSuccessed) {
        if (isSuccessed) {
            resultBlock(resultObject,1);
        }else{
            resultBlock(nil,0);
        }
    }];
}


//post--
+(void)ylNonTokenRequestWithGET:(NSString *)urlString parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
      NSMutableDictionary *para = [parameter mutableCopy];
    NSString *urlStr = urlStr = [NSString stringWithFormat:@"%@%@",[UGURLConfig baseURL],urlString];
    NSLog(@"接口&&参数%@%@",urlStr,para);
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [BaseNetManager requestWithPost:urlStr header:dict parameters:para successBlock:^(id resultObject, int isSuccessed) {
        if (isSuccessed) {
            resultBlock(resultObject,1);
        }else{
            resultBlock(nil,0);
        }
    }];
}
//get请求
+(void)requestWithGET:(NSString *)urlString parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
    
    for (int i =0; i<parameter.allKeys.count; i++) {
        NSString *key = parameter.allKeys[i];
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,parameter[key]];
        if (i<parameter.allKeys.count-1) {
            string = [string stringByAppendingString:@"&"];
        }
        string = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)string, NULL, (CFStringRef)@"!*'();:@+$,/?%#[]", kCFStringEncodingUTF8));
        urlString = [urlString stringByAppendingString:string];
    }
    
    NSString *urlStr = urlStr = [NSString stringWithFormat:@"%@%@",[UGURLConfig baseURL],urlString];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    //设置header内容
    [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
    NSString *firstName = [defaults objectForKey:executableFile];
//    if (!firstName) {
//        [request addValue:@"" forHTTPHeaderField:@"x-auth-token"];
//    }else{
//        [request addValue:firstName forHTTPHeaderField:@"x-auth-token"];
//    }
    //登录后，后台返回。直接丢回给后台.
    NSString *access_auth_token = [defaults objectForKey:@"access-auth-token"];
    [request addValue: access_auth_token ? access_auth_token : @"" forHTTPHeaderField:@"access-auth-token"];
    [request addValue:[UG_MethodsTool accessAuthUgcoinEncryption] forHTTPHeaderField:@"access-auth-ugcoin"];
    
    //MARK:--请求返回国际化
    NSString *language= LocalizationKey(@"responseLanguage");
    [request addValue:language forHTTPHeaderField:@"Accept-Language"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && [BaseNetManager showResponseCode:response] == 200) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(result,1);
            }];
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(nil,0);
            }];
        }
        
    }];
    NSLog(@"接口：%@ %@",url,parameter);
    [task resume];
    
}

//get请求2
+(void)requesByAppendtWithGET:(NSString *)urlString parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
  
    for (int i =0; i<parameter.allKeys.count; i++) {
        NSString *key = parameter.allKeys[i];
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,parameter[key]];
        if (i<parameter.allKeys.count-1) {
            string = [string stringByAppendingString:@"&"];
        }
        string = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)string, NULL, (CFStringRef)@"!*'();:@+$,/?%#[]", kCFStringEncodingUTF8));
        urlString = [urlString stringByAppendingString:string];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && [BaseNetManager showResponseCode:response] == 200) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(result,1);
            }];
            
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(nil,0);
            }];
        }
        
    }];
    NSLog(@"GetURL：%@",url);
    [task resume];
}

//post请求1(不设置header)
+(void)requestWithPost:(NSString *)urlStr parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:10];
    request.HTTPMethod = @"POST";
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSString *para = @"";
    for (int i =0; i<parameter.allKeys.count; i++) {
        NSString *key = parameter.allKeys[i];
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,parameter[key]];
        if (i<parameter.allKeys.count-1) {
            string = [string stringByAppendingString:@"&"];
        }
        para = [para stringByAppendingString:string];
    }
    
    para = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)para, NULL, (CFStringRef)@"!*'();:@+$,/?%#[]", kCFStringEncodingUTF8));
    request.HTTPBody = [para dataUsingEncoding:NSUTF8StringEncoding];
    
#warning 开启HTTPS验证
//    [self shareNetManager];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:netManager delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && [BaseNetManager showResponseCode:response] == 200) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(result,1);
            }];
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(nil,0);
            }];
        }
    }];
    [task resume];
    
}

//post请求2（设置header）
+(void)requestWithPost:(NSString *)urlStr header:(NSDictionary *)header parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
     NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:30];
    request.HTTPMethod = @"POST";
    //设置header内容
    [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *firstName = [defaults objectForKey:executableFile];
//    if (!firstName) {
//        [request addValue:@"" forHTTPHeaderField:@"x-auth-token"];
//    }else{
//        [request addValue:firstName forHTTPHeaderField:@"x-auth-token"];
//    }
    
    //登录后，后台返回。直接丢回给后台.
    NSString *access_auth_token = [defaults objectForKey:@"access-auth-token"];
    [request addValue: access_auth_token ? access_auth_token : @"" forHTTPHeaderField:@"access-auth-token"];
    [request addValue:[UG_MethodsTool accessAuthUgcoinEncryption] forHTTPHeaderField:@"access-auth-ugcoin"];
    
    //MARK:--请求返回国际化
    NSString *language= LocalizationKey(@"responseLanguage");
    [request addValue:language forHTTPHeaderField:@"Accept-Language"];
    //设置body内容
    NSString *para = @"";
    for (int i =0; i<parameter.allKeys.count; i++) {
        NSString *key = parameter.allKeys[i];
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,parameter[key]];
        if (i<parameter.allKeys.count-1) {
            string = [string stringByAppendingString:@"&"];
        }
        para = [para stringByAppendingString:string];
    }
    
    para = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)para, NULL, (CFStringRef)@"!*'();:@+$,/?%#[]", kCFStringEncodingUTF8));
    request.HTTPBody = [para dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

#warning 开启HTTPS验证
//    [self shareNetManager];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:netManager delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       // [BaseNetManager showResponseCode:response];
        
        if (data && [BaseNetManager showResponseCode:response] == 200) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(result,1);
            }];
        }
        else{
            //登录失效
            if ([BaseNetManager showResponseCode:response] == 4000) {
                [[UGManager shareInstance] signout:^{
                    
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"登录失效" object:@"" userInfo:nil];
            }else{
                //异常上报
                [UG_MethodsTool reportErrorMessage:[NSNumber numberWithInt : [BaseNetManager showResponseCode:response]] WithReson: @" " WithUrl:url];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(nil,0);
            }];
        }
    }];
    [task resume];
    
}


//上传图片
+(void)uploadImageWith:(NSString *)urlStr imageData:(NSData *)imageData successBlock:(ResultBlock)resultBlock{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:20];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
#warning 开启HTTPS验证
//    [self shareNetManager];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:netManager delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionUploadTask * uploadtask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && [BaseNetManager showResponseCode:response]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(data,1);
            }];
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                resultBlock(nil,0);
            }];
        }
    }];
    [uploadtask resume];
}

+(void)POSTrequestByDesWithPost:(NSString *)apiStr header:(NSDictionary *)header parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
    NSString * urlString = [[UGURLConfig baseURL] stringByAppendingString:apiStr];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",interval];
    NSLog(@"timeString:%@",timeString);
    printf("---------------------------------------\n");
    
    //NSString *UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    printf("---------------------------------------\n");
    
    NSLog(@"para:%@",parameter);
    printf("---------------------------------------\n");
    
   
//    if (parameter) {
//        data = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:nil];
//    }
 
    NSMutableDictionary *dic = [parameter mutableCopy];
  
    [BaseNetManager requestWithPost:urlString header:header parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        if (isSuccessed) {
            resultBlock(resultObject,1);
        }else{
            resultBlock(nil,0);
        }
    }];

}

//网络请求
+ (void)requestByDesWithPost:(NSString *)apiStr header:(NSDictionary *)header parameters:(NSDictionary *)parameter successBlock:(ResultBlock)resultBlock{
    NSString * urlString = [[UGURLConfig baseURL] stringByAppendingString:apiStr];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",interval];
    NSLog(@"timeString:%@",timeString);
    printf("---------------------------------------\n");
    
    //NSString *UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSData *data = nil;
    if (parameter) {
        data = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:nil];
    }
    NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json:%@",json);
    printf("---------------------------------------\n");
    
 
    printf("---------------------------------------\n");
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    [BaseNetManager requestWithPost:urlString header:header parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        if (isSuccessed) {
            resultBlock(resultObject,1);
        }else{
            resultBlock(nil,0);
        }
    }];
}

//网络请求
+ (void)requestByDesWithPost1:(NSString *)apiStr header:(NSDictionary *)header parameters:(NSDictionary *)parameter andToken:(NSString *)token successBlock:(ResultBlock)resultBlock{
    NSString * urlString = [[UGURLConfig baseURL] stringByAppendingString:apiStr];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",interval];
    NSLog(@"timeString:%@",timeString);
    printf("---------------------------------------\n");
    
  
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    [BaseNetManager requestWithPost:urlString header:header parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        if (isSuccessed) {
            resultBlock(resultObject,1);
        }else{
            resultBlock(nil,0);
        }
    }];
}

/* 输出http响应的状态码 */
+ (int)showResponseCode:(NSURLResponse *)response {
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    NSDictionary *allHeaderFields = httpResponse.allHeaderFields;
//    NSString*tokenstring=allHeaderFields[@"x-auth-token"];
//    if (tokenstring) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:tokenstring forKey:executableFile];
//        [defaults synchronize];
//    };
    NSLog(@"responseStatusCode--%ld" ,(long)responseStatusCode);
    return (int)responseStatusCode;
}
//MARK:---数据流上传图片
+(void)uploadImageDataWith:(NSString *)urlStr imageData:(NSData *)imageData successBlock:(ResultBlock)resultBlock{
    NSString *urlString=[[UGURLConfig baseURL] stringByAppendingString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
#warning  开启HTTPS验证
 /*   NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    NSSet *certSet = [NSSet setWithObject:certData];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    __weak AFHTTPSessionManager *_manager = [AFHTTPSessionManager manager];
    _manager.securityPolicy = policy;
    //关闭缓存避免干扰测试r
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //客户端请求验证 重写 setSessionDidReceiveAuthenticationChallengeBlock 方法
    __weak typeof(self)weakSelf = self;
    [_manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([_manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition =NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client"ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12])
            {
                NSLog(@"client.p12:not exist");
            }
            else
            {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                
                if ([[weakSelf class]extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
                {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition =NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
 */

    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    dic[@"x-auth-token"] = [YLUserInfo shareUserInfo].token;
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
    NSString *firstName = [[NSUserDefaults standardUserDefaults] objectForKey:executableFile];
//    dic[@"x-auth-token"] = firstName;
    dic[@"Content-Type"] = @"application/x-www-form-urlencoded";
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageDatas = imageData;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"上传进度");
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            resultBlock(responseObject,1);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [EasyShowLodingView hidenLoding];
        //上传失败
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            resultBlock(nil,0);
        }];
    }];
}


+(BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"niuniuhaoguanjia"
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}


#pragma mark - NSURLSessionDelegate 代理方法

//主要就是处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"didReceiveChallenge ");
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"server ---------");
        //        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        NSString *host = challenge.protectionSpace.host;
        NSLog(@"%@", host);
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
    else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate])
    {
        //客户端证书认证
        //TODO:设置客户端证书认证
        // load cert
        NSLog(@"client");
        NSString *path = [[NSBundle mainBundle]pathForResource:@"client"ofType:@"p12"];
        NSData *p12data = [NSData dataWithContentsOfFile:path];
        CFDataRef inP12data = (__bridge CFDataRef)p12data;
        SecIdentityRef myIdentity;
        OSStatus status = [self extractIdentity:inP12data toIdentity:&myIdentity];
        if (status != 0) {
            return;
        }
        SecCertificateRef myCertificate;
        SecIdentityCopyCertificate(myIdentity, &myCertificate);
        const void *certs[] = { myCertificate };
        CFArrayRef certsArray =CFArrayCreate(NULL, certs,1,NULL);
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
        //        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        //         网上很多错误代码如上，正确的为：
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

- (OSStatus)extractIdentity:(CFDataRef)inP12Data toIdentity:(SecIdentityRef*)identity {
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("123456");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    if (securityError == 0)
    {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    else
    {
        NSLog(@"clinet.p12 error!");
    }
    
    if (options) {
        CFRelease(options);
    }
    return securityError;
}

@end
