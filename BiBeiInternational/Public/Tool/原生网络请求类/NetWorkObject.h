//
//  NetWorkObject.h
//  Nick'Test
//
//  Created by 孙锟 on 2019/3/18.
//  Copyright © 2019 Nick-Test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//网络请求成功,带回结果
typedef void(^success)(id responseObject);
//网络请求失败,带回错误
typedef void(^failure)(NSError *error);

@interface NetWorkObject : NSObject

+(instancetype)shareInstance;

-(void)getDataWithURL:(NSString *)urlStr SuccessBlock:(success)success FailureBlock:(failure)failure;

-(void)postDataWithURL:(NSString *)urlStr andPostDic:(NSMutableDictionary*)postDic SuccessBlock:(success)success FailureBlock:(failure)failure;

//彩盟对接
-(void)postDataToCreatAlipayWithURL:(NSString *)urlStr andPostDic:(NSMutableDictionary*)postDic SuccessBlock:(success)success FailureBlock:(failure)failure;

@end

NS_ASSUME_NONNULL_END
