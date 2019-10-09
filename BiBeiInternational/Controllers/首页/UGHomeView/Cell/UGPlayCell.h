//
//  UGPlayCell.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "bannerCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPlayCell : UGBaseTableViewCell

@property (copy, nonatomic) void(^backToHomeVCBlock)(bannerCellModel *model);

-(void)refreshUGPlayCellWithArray:(NSArray *)itemsArray;
@end

NS_ASSUME_NONNULL_END
