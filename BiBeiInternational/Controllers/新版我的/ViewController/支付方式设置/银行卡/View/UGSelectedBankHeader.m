//
//  UGSelectedBankHeader.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSelectedBankHeader.h"

@interface UGSelectedBankHeader ()

@property (nonatomic, strong) UILabel *firstLetterLabel;
@property (nonatomic,strong)UIButton *Btn;
@property (nonatomic,strong)UIView *backView;

@end

@implementation UGSelectedBankHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.backView addSubview:self.firstLetterLabel];
        [self.backView addSubview:self.Btn];
        [self.contentView addSubview:self.backView];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)firstLetterLabel {
    if (!_firstLetterLabel) {
        _firstLetterLabel = [[UILabel alloc] initWithFrame: CGRectMake(60, 0, UG_SCREEN_WIDTH-45-14, 44)];
        _firstLetterLabel.textColor = [UIColor blackColor];
        _firstLetterLabel.font = [UIFont systemFontOfSize:14];
        _firstLetterLabel.text = @"其他";
    }
    return _firstLetterLabel;
}

-(UIButton *)Btn{
    if (!_Btn) {
        _Btn = [[UIButton alloc] initWithFrame:CGRectMake(13, (44-25)/2.0, 25, 25)];
        [_Btn setImage:[UIImage imageNamed:@"other_bank"] forState:UIControlStateNormal];
        [_Btn addTarget:self action:@selector(selectedView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Btn;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH_S-30-16, 44)];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedView)];
        [_backView addGestureRecognizer:tag];
    }
    return _backView;
}

-(void)selectedView{
    if (self.sectionBlock) {
        self.sectionBlock();
    }
}

@end
