//
//  UGMineTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMineTableViewCell.h"

@interface UGMineTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UGMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTitle:(NSString *)title imageName:(NSString *)imageName firstCell:(BOOL)firstCell lastCell:(BOOL)lastCell {
    self.leftImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
    if (firstCell || lastCell) {
        [self setupRoundedRecWithTop:firstCell];
    }
}

- (void)setupRoundedRecWithTop:(BOOL)top {
    CGRect rect = self.bounds;
    UIRectCorner rectConrner = top ? (UIRectCornerTopLeft | UIRectCornerTopRight) :(UIRectCornerBottomLeft | UIRectCornerBottomRight);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectConrner cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
