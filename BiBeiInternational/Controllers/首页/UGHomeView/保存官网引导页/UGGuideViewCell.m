//
//  UGGuideViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2019/7/10.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGuideViewCell.h"

@interface UGGuideViewCell()
@property (weak, nonatomic) IBOutlet UILabel *alertTittleLabel;

@property (weak, nonatomic) IBOutlet UILabel *step1Label;

@property (weak, nonatomic) IBOutlet UILabel *step2Label;

@property (weak, nonatomic) IBOutlet UILabel *step3Label;

@property (weak, nonatomic) IBOutlet UILabel *step4Label;

@property (weak, nonatomic) IBOutlet UILabel *step5Label;


@end

@implementation UGGuideViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.step1Label.font = UG_AutoFont(12);
    self.step2Label.font = UG_AutoFont(12);
    self.step3Label.font = UG_AutoFont(12);
    self.step4Label.font = UG_AutoFont(12);
    self.step5Label.font = UG_AutoFont(12);
    self.alertTittleLabel.font = UG_AutoFont(12);
    //cell 圆角
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
}

//Cell  设置边距
- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为10;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    static CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += margin;
    frame.size.height -= margin;
    [super setFrame:frame];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
