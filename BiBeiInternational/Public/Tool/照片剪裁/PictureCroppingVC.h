//
//  "PictureCroppingVC.h"
//  OriginalTools
//
//  Created by keniu on 2019/8/12.
//  Copyright © 2019 NickSun. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void(^PictureCroppingVCBlock)(UIImage *image);

@interface PictureCroppingVC : UIViewController
@property (strong, nonatomic) UIImage *image;
@property(nonatomic,copy)PictureCroppingVCBlock croppingBlock;
@end
