//
//  EditPhotoVC.h
//  OriginalTools
//
//  Created by keniu on 2019/8/12.
//  Copyright © 2019 NickSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ImageBlock)(UIImage *image);

@interface EditPhotoVC : UIViewController

@property (nonatomic, copy) ImageBlock imageblock;

@property(nonatomic,assign)BOOL isIDCard;
@end

NS_ASSUME_NONNULL_END
