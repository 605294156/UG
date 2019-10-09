//
//  UGPayMethodView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOTCPayDetailModel.h"
#import "UGPayInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayMethodView : UIView

@property (nonatomic, strong) UGOTCPayDetailModel *payDetail;

@property (nonatomic, strong) UGPayInfoModel *payInfoModel;


@property (nonatomic, strong) NSArray <NSString *> *payWays;


/**
 计算出来的宽度
 */
@property (nonatomic, assign) CGFloat viewWidth;


@end

NS_ASSUME_NONNULL_END
