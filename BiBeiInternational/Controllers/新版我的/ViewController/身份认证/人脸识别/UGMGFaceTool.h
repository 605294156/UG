//
//  UGMGFaceTool.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMGFaceTool : NSObject

typedef void (^UGMGFaceDetectBlock)(NSUInteger Code, NSString *Message,NSString *key);

+(void)ug_mgFaceVerifyWith:(UIViewController *__nonnull)detectVC WithTypeStr:(NSString *)typeStr WithUserName:(NSString *)username callback:(UGMGFaceDetectBlock)result;

@end

NS_ASSUME_NONNULL_END
