//
//  UGBaseTableViewCell.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseTableViewCell.h"

@implementation UGBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupCustomStyle];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCustomStyle];
    }
    return self;
}

- (void)setupCustomStyle {
    if ([self useCustomStyle]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 使用自定义的风格  默认YES
 默认带边框、调整了左右间距15
 */
- (BOOL)useCustomStyle {
    return YES;
}


- (void)setFrame:(CGRect)frame {
    if ([self useCustomStyle]) {
        static CGFloat margin = 14;
        frame.origin.x = margin;
        frame.size.width -= 2 * frame.origin.x;
    }
    [super setFrame:frame];
}


@end
