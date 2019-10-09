//
//  UGRatePopView.h
//  BiBeiInternational
//
//  Created by conew on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGRateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGRatePopView : UIView
- (instancetype)initWithViewFrame:( CGRect)frame WithDataArr:(NSArray *)dataArr WithHandle:(void (^)(UGSlaveRateModel *model))clickHandle;
-(void)showMenuWithFrame:(CGRect)viewRect;
-(void)hideMenuWithFrame:(CGRect)viewRect;
@end

NS_ASSUME_NONNULL_END
