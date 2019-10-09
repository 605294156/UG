//
//  UGHomeMarketCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

@class UGSymbolThumbModel;

@interface UGHomeMarketCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hournumLabel;
@property (weak, nonatomic) IBOutlet UILabel *changenumLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *percenLabel;
-(void)configDataWithModel:(UGSymbolThumbModel*)model;
@end
