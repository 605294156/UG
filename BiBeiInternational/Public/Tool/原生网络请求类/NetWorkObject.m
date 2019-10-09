//
//  NetWorkObject.m
//  Nick'Test
//
//  Created by 孙锟 on 2019/3/18.
//  Copyright © 2019 Nick-Test. All rights reserved.
//

#import "NetWorkObject.h"
#import <AFNetworking.h>
@implementation NetWorkObject

+(instancetype)shareInstance
{
    static NetWorkObject *netWork = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
       
        netWork = [[NetWorkObject alloc]init];
        
    });
    
    return netWork;
    
}

-(void)getDataWithURL:(NSString *)urlStr SuccessBlock:(success)success FailureBlock:(failure)failure
{
   NSURL *url = [NSURL URLWithString:urlStr];
   NSURLRequest *request = [NSURLRequest requestWithURL:url];
// application/json  text/plain
 [request setValue:@"application/json" forKey:@"Content-Type"];
 NSURLSession *session = [NSURLSession sharedSession];
 NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
     if (error == nil) {

         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         success(dict);
     }
    else
    {
        failure(error);
    }
    
}];
    
//5.执行任务
[dataTask resume];

    
}

-(void)postDataWithURL:(NSString *)urlStr andPostDic:(NSMutableDictionary*)postDic SuccessBlock:(success)success FailureBlock:(failure)failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forKey:@"Content-Type"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDic options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = postData;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(dic);
        }
        else
        {
            failure(error);
        }
    } ];
    [dataTask resume];
}


//彩盟对接
-(void)postDataToCreatAlipayWithURL:(NSString *)urlStr andPostDic:(NSMutableDictionary*)postDic SuccessBlock:(success)success FailureBlock:(failure)failure
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:postDic error:nil];
    NSLog(@"postDic = %@",postDic);
    
    request.timeoutInterval = 10.f;
    NSString *access_auth_token = [NSUserDefaultUtil GetDefaults:@"access-auth-token"];
    NSString *language= LocalizationKey(@"responseLanguage");
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:access_auth_token forHTTPHeaderField:@"access-auth-token"];
    [request addValue:language forHTTPHeaderField:@"Accept-Language"];
    [request addValue:[UG_MethodsTool accessAuthUgcoinEncryption] forHTTPHeaderField:@"access-auth-ugcoin"];
    NSLog(@"allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"-----responseObject===%@+++++",responseObject);
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 请求成功数据处理
                success(responseObject);
            } else {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                success(dic);
                
            }
        } else {
            NSLog(@"请求失败error=%@", error);
            failure(error);
        }
    }];
    [task resume];
    
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
//    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    [request setTimeoutInterval:20];
//    
//    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    [request addValue:access_auth_token forHTTPHeaderField:@"access-auth-token"];
//    [request addValue:language forHTTPHeaderField:@"Accept-Language"];
//    [request addValue:[UG_MethodsTool accessAuthUgcoinEncryption] forHTTPHeaderField:@"access-auth-ugcoin"];
//    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
//    request.HTTPBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
//
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error == nil)
//        {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            success(dic);
//        }
//        else
//        {
//            failure(error);
//        }
//    } ];
//    [dataTask resume];
    
    
}
@end
