//
//  UIImage+Expand.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UIImage+Expand.h"

@implementation UIImage (Expand)

+ (UIImage*)imageWithColor:(UIColor*)color {
    CGRect ret= CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(ret.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context,ret);
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
