//
//  UGSetionHeaderView.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSetionHeaderView.h"

@interface UGSetionHeaderView ()

@property (nonatomic, strong) UILabel *firstLetterLabel;
@property (nonatomic,strong)UIView *backView;

@end

@implementation UGSetionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.firstLetterLabel];
    }
    return self;
}

- (void)setLetter:(NSString *)letter {
    _letter = letter;
    CGSize size = [letter boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_S, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.firstLetterLabel.font} context:nil].size;
    self.firstLetterLabel.text = letter;
    self.firstLetterLabel.frame = CGRectMake(14, (30 - size.height)/2.0, size.width, size.height);
}

#pragma mark - getter
- (UILabel *)firstLetterLabel {
    if (!_firstLetterLabel) {
        _firstLetterLabel = [[UILabel alloc] init];
        _firstLetterLabel.textColor = UG_MainColor;
        _firstLetterLabel.font = [UIFont systemFontOfSize:14];
    }
    return _firstLetterLabel;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH_S-30-16, 30)];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor colorWithHexString:@"E8F5FF"];
    }
    return _backView;
}

@end
