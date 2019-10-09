//
//  FaceIDDetectError.h
//  MGFaceIDDetect
//
//  Created by MegviiDev on 2017/7/21.
//  Copyright © 2017年 megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGFaceIDDetectConfig.h"

@interface FaceIDDetectError : NSObject

@property (nonatomic, assign) ZZPlatformErrorType errorCode;

@property (nonatomic, strong) NSString* errorMessage;

- (instancetype)initWithErrorCode:(ZZPlatformErrorType)errorCode;

@end
