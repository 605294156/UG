//
//  UGAssetsTableViewCell.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGAssetsTableViewCell.h"


@interface UGAssetsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end

@implementation UGAssetsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateBalance:(NSString *)balance cny:(NSString *)cny type:(NSString *)type {
    self.balanceLabel.text =!UG_CheckStrIsEmpty(balance)? balance : @"--";
    self.typeLabel.text =!UG_CheckStrIsEmpty(type)? type : @"UG";
    self.cnyLabel.text =!UG_CheckStrIsEmpty(cny)? cny : @"--";
}

@end
