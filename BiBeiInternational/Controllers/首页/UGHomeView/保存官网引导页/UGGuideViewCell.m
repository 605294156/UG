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
//    self.step1Label.font = UG_AutoFont(12);
//    self.step2Label.font = UG_AutoFont(12);
//    self.step3Label.font = UG_AutoFont(12);
//    self.step4Label.font = UG_AutoFont(12);
//    self.step5Label.font = UG_AutoFont(12);
//    self.alertTittleLabel.font = UG_AutoFont(12);
    
    NSMutableAttributedString *titleAttrStr = [[NSMutableAttributedString alloc] initWithString:self.alertTittleLabel.text];
    [titleAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fd1200"] range:NSMakeRange(26, 16)];
    self.alertTittleLabel.attributedText = titleAttrStr;
    
    NSMutableAttributedString *step1AttrStr = [[NSMutableAttributedString alloc] initWithString:self.step1Label.text];
    [step1AttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4f6ebc"] range:NSMakeRange(17, 9)];
    self.step1Label.attributedText = step1AttrStr;
    
    NSMutableAttributedString *step2AttrStr = [[NSMutableAttributedString alloc] initWithString:self.step2Label.text];
    [step2AttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4f6ebc"] range:NSMakeRange(4, 4)];
    [step2AttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4f6ebc"] range:NSMakeRange(11, 9)];
    self.step2Label.attributedText = step2AttrStr;
    
    NSMutableAttributedString *step3AttrStr = [[NSMutableAttributedString alloc] initWithString:self.step3Label.text];
    [step3AttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4f6ebc"] range:NSMakeRange(9, 4)];
    self.step3Label.attributedText = step3AttrStr;
    
    NSMutableAttributedString *step5AttrStr = [[NSMutableAttributedString alloc] initWithString:self.step5Label.text];
    [step5AttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4f6ebc"] range:NSMakeRange(4, 4)];
    [step5AttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4f6ebc"] range:NSMakeRange(11, 4)];
    self.step5Label.attributedText = step5AttrStr;
}

//Cell  设置边距
- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为10;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += 0;
    frame.size.height -= margin;
    [super setFrame:frame];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
