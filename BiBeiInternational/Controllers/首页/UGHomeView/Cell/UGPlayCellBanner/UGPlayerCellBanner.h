//
//  UGPlayerCellBanner.h
//  BiBeiInternational
//
//  Created by keniu on 2019/5/14.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseView.h"
#import "bannerCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPlayerCellBanner : UGBaseView

- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize;

@property (copy, nonatomic) NSArray *items;

@property (copy, nonatomic) void(^cellClick)(UGPlayerCellBanner *barnerview,bannerCellModel *model);

@end

NS_ASSUME_NONNULL_END
