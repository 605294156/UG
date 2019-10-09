//
//  UGMGFaceTool.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGMGFaceTool.h"
#import <MGFaceIDDetect/MGFaceIDDetect.h>
#import "UGGetBizToken.h"

@implementation UGMGFaceTool

+(void)ug_mgFaceVerifyWith:(UIViewController *__nonnull)detectVC WithTypeStr:(NSString *)typeStr WithUserName:(NSString *)username callback:(UGMGFaceDetectBlock)result{
    
// face++人脸识别只支持真机  这里做一个真机\模拟器判断  避免 clang 错误
#if TARGET_IPHONE_SIMULATOR
     [detectVC.view ug_showToastWithToast:@"很抱歉,模拟器不支持人脸识别操作"];
#elif TARGET_OS_IPHONE
    [detectVC.view ug_showMBProgressHudOnKeyWindow];
    [self getBizTokenWithTypeStr:typeStr WithUserName:username Block:^(UGApiError *apiError, id object) {
        if (object) {
                FaceIDDetectError* error;
                MGFaceIDDetectManager* faceIDDetectManager = [[MGFaceIDDetectManager alloc] initFaceIdManagerWithToken:object error:&error];
                [detectVC.view ug_hiddenMBProgressHudOnKeyWindow];
                if (!faceIDDetectManager && error) {
                    //在这里 回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [detectVC.view ug_showToastWithToast:[NSString  stringWithFormat:@"%d : %@",(int)error.errorCode,error.errorMessage]];
                    });
                }else{
                    [faceIDDetectManager startDetect:detectVC callback:^(NSUInteger Code, NSString *Message) {
                        if (result) {
                            result(Code,Message,object);
                        }
                    }];
                }
            
        }else{
                [detectVC.view ug_hiddenMBProgressHudOnKeyWindow];
                //在这里 回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                  [detectVC.view ug_showToastWithToast:apiError.desc];
                });
        }
    }];
#endif
}

//先从服务器拿到 鉴权 bz_token
+(void)getBizTokenWithTypeStr:(NSString *)typeStr WithUserName:(NSString *)username Block:(UGRequestCompletionBlock)completionBlock{
    UGGetBizToken *api = [UGGetBizToken new];
    api.target = typeStr;
    api.username = username;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (completionBlock) {
            completionBlock(apiError,object);
        }
    }];
}

@end
