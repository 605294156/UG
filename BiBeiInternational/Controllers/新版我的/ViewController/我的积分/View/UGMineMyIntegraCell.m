//
//  UGMineMyIntegraCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGMineMyIntegraCell.h"

@interface UGMineMyIntegraCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbael;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integraLabel;
@end

@implementation UGMineMyIntegraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(BOOL)useCustomStyle{
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UGIntegrationModel *)model{
    self.integraLabel.text =! UG_CheckStrIsEmpty(model.responseScore) ? model.responseScore : @"";
    self.timeLabel.text =[UG_MethodsTool getFriendyWithStartTime:model.createTime];
    self.imgIcon.image = [UIImage imageNamed:[model.score doubleValue] > 0 ? @"add_intergration" : @"deduct_marks"];
    self.titleLbael.text = [model returnStatus];
}


@end
