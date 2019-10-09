//
//  OTCComplaintPhotoCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTCComplaintModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCComplaintPhotoCell : UITableViewCell


@property(nonatomic, copy) void(^tapPhotosHandle)(UIButton *addButton);

@property(nonatomic ,strong) OTCComplaintModel *model;
@property(nonatomic ,assign) BOOL reApeal; //重新提交

@end

NS_ASSUME_NONNULL_END
