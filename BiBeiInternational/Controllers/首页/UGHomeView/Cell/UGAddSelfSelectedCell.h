//
//  UGAddSelfSelectedCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/25.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
@class symbolModel;
@interface UGAddSelfSelectedCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hournumLabel;
@property (weak, nonatomic) IBOutlet UILabel *changenumLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *percenLabel;
@property (nonatomic,copy)void(^clickBtn)(id obj);
-(void)cellClickBtn:(void(^)(id obj)) block;
-(void)configDataWithModel:(symbolModel*)model;
@end
