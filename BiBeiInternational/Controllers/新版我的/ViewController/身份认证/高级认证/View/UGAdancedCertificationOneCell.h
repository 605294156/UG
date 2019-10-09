//
//  UGAdancedCertificationOneCell.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGAdancedCertificationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGAdancedCertificationOneCell : UGBaseTableViewCell

@property(nonatomic, strong) UGAdancedCertificationModel *model;
@property(nonatomic, strong) UGAdancedCertificationModel *model2;

/**
 拍照或选择图片
 */
@property(nonatomic, copy) void(^tapPhotosHandle)(UIImageView *imageView);

/**
 拍照或选择图片
 */
@property(nonatomic, copy) void(^tapPhotosTwoHandle)(UIImageView *imageView);

/**
 放大展示图片
 */
@property(nonatomic, copy) void(^showPhotosHandle)(UIImage *image,BOOL isCheck);

/**
 放大展示图片
 */
@property(nonatomic, copy) void(^showPhotosTwoHandle)(UIImage *image,BOOL isCheck);

@end

NS_ASSUME_NONNULL_END
