//
//  LBXPermission.m
//  LBXKits
//
//  Created by lbx on 2017/9/7.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermission.h"
#import <UIKit/UIKit.h>

#import "LBXPermissionCamera.h"
#import "LBXPermissionPhotos.h"
#import "LBXPermissionLocation.h"
#import "LBXPermissionMicrophone.h"
#import "LBXPermissionNetwork.h"

@implementation LBXPermission


+ (BOOL)isServicesEnabledWithType:(LBXPermissionType)type
{
    if (type == LBXPermissionType_Location) {
        return [LBXPermissionLocation isServicesEnabled];
    }
    
    return YES;
}

+ (BOOL)isDeviceSupportedWithType:(LBXPermissionType)type
{
    return YES;
}

+ (BOOL)authorizedWithType:(LBXPermissionType)type
{
    switch (type) {
        case LBXPermissionType_Location:
            return [LBXPermissionLocation authorized];
            break;
        case LBXPermissionType_Camera:
            return [LBXPermissionCamera authorized];
            break;
        case LBXPermissionType_Photos:
            return [LBXPermissionPhotos authorized];
            break;
        case LBXPermissionType_Microphone:
            return [LBXPermissionMicrophone authorized];
            break;
        case LBXPermissionType_Network:
            return [LBXPermissionNetwork authorized];
            break;
        default:
            break;
    }
    return NO;
}

+ (void)authorizeWithType:(LBXPermissionType)type completion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    switch (type) {
        case LBXPermissionType_Location:
            return [LBXPermissionLocation authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Camera:
            return [LBXPermissionCamera authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Photos:
            return [LBXPermissionPhotos authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Microphone:
            return [LBXPermissionMicrophone authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Network:
            return [LBXPermissionNetwork authorizeWithCompletion:completion];
            break;
        default:
            break;
    }
}

@end
