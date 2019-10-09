//
//  UGAdancedCertificationCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGAdancedCertificationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAdancedCertificationCell : UGBaseTableViewCell


@property(nonatomic, strong) UGAdancedCertificationModel *model;
/**
 查看大图按钮 根据情况隐藏
 */
@property (weak, nonatomic) IBOutlet UIButton *chekBtn;

/**
 拍照或选择图片
 */
@property(nonatomic, copy) void(^tapPhotosHandle)(UIImageView *imageView);


/**
 放大展示图片
 */
@property(nonatomic, copy) void(^showPhotosHandle)(UIImage *image,BOOL isCheck);

@end

NS_ASSUME_NONNULL_END
