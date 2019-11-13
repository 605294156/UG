//
//  UGOTCHeadView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCHeadView.h"
#import "TRRightChooseView.h"
#import "PopView.h"

@interface UGOTCHeadView ()

//@property (nonatomic, strong) UGButton *releaseButton;//发布广告按钮
//@property (nonatomic, strong) UGButton *filterButton;//筛选按钮
@property (nonatomic, strong) UILabel *dealLabel;//交易
@property (nonatomic, strong) UIButton *releaseAdv;//发布广告
@property (nonatomic, strong) UIImageView *line,*line1;
@property(nonatomic, strong) TRRightChooseView *rightChooseView;//右侧选择
@property(nonatomic, strong) NSArray <MoreChooseDataModel *>*rightArray;//右侧筛选数据
@property (nonatomic, strong) OTCFilterModel *filterModel;//输入或选取的值，直接传给UGOTCListApi

@end

@implementation UGOTCHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.filterModel = [OTCFilterModel new];
//        self.buttonTitle = @"我要出售";
        self.rightArray = [MoreChooseDataModel mj_objectArrayWithFilename:@"XX.plist"];
        [self setupButtons];
    }
    return self;
}

#pragma mark - SetView Method
- (void)setupButtons {
    
//    [self addSubview:self.filterButton];
//    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self).mas_offset(8);
//        make.leading.mas_equalTo(self).mas_offset(25);
//        make.size.mas_equalTo(CGSizeMake(88, 34));
//    }];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@0.5);
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(self.line.mas_height);
    }];
    
    [self addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.height.equalTo(@2);
        make.width.equalTo(@34);
        make.centerY.equalTo(self.line.mas_centerY);
    }];
    
    [self addSubview:self.dealLabel];
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.releaseAdv];
    [self.releaseAdv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.mas_centerY);
    }];

//    [self addSubview:self.releaseButton];
//    [self.releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(self).mas_offset(-25);
//        make.top.mas_equalTo(self.dealLabel.mas_top);
//        make.height.mas_equalTo(self.dealLabel.mas_height);
//        make.leading.mas_equalTo(self.dealLabel.mas_trailing).mas_offset(25);
//    }];
    
}


#pragma mark - Sel Method

- (void)clickRelease:(UGButton *)sender {
    if ([sender.titleLabel.text containsString:@"出售"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(headViewReleseToSell)]) {
            [self.delegate headViewReleseToSell];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(headViewReleseToBuy)]) {
            [self.delegate headViewReleseToBuy];
        }
    }
}

- (void)clickFilter:(nullable UGButton *)sender {
    PopView *popView = [PopView popSideContentView:self.rightChooseView direct:PopViewDirection_SlideFromRight];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    @weakify(self);
    popView.didRemovedFromeSuperView = ^{
        @strongify(self);
        self.rightChooseView = nil;
    };
}


#pragma mark - Setter Method

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self.releaseAdv setTitle:buttonTitle forState:UIControlStateNormal];
}


#pragma mark - Getter Method

//- (UGButton *)releaseButton {
//    if (!_releaseButton) {
//        _releaseButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleWhite];
//        [_releaseButton set forState:UIControlStateNormal];
//        [_releaseButton setBackgroundColor:[UIColor redColor]];
//        [_releaseButton addTarget:self action:@selector(clickRelease:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _releaseButton;
//}

- (UIButton *) releaseAdv{
    if (!_releaseAdv) {
        NSString *str = @"我要购买";UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        CGSize sizeToFit = [str sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 30) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        UIImage *image = [UIImage imageNamed:@"OT_home_right_arrows"];
        _releaseAdv = [UIButton buttonWithType:UIButtonTypeCustom];
        [_releaseAdv setTitle:str forState:UIControlStateNormal];
        [_releaseAdv setImage:image forState:UIControlStateNormal];
        [_releaseAdv setTitleColor:HEXCOLOR(0x6684c7) forState:UIControlStateNormal];
        [[_releaseAdv titleLabel] setFont:font];
        [_releaseAdv setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [_releaseAdv setImageEdgeInsets:UIEdgeInsetsMake(0, sizeToFit.width, 0, -sizeToFit.width)];
        [_releaseAdv addTarget:self action:@selector(clickRelease:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseAdv;
}

- (UIImageView *)line{
    if (!_line) {
        _line = UIImageView.new;
        _line.backgroundColor = HEXCOLOR(0xdddddd);
    }
    return _line;
}

- (UIImageView *)line1{
    if (!_line1) {
        _line1 = UIImageView.new;
        _line1.backgroundColor = self.line.backgroundColor;
    }
    return _line1;
}

- (UIImageView *)line2{
    if (!_line2) {
        _line2 = UIImageView.new;
        _line2.backgroundColor = HEXCOLOR(0x4264b8);
    }
    return _line2;
}

//- (UGButton *)filterButton {
//    if (!_filterButton) {
//        _filterButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleWhite];
//        [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
//        [_filterButton addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _filterButton;
//}

- (UILabel *)dealLabel{
    if (!_dealLabel) {
        _dealLabel = UILabel.new;
        _dealLabel.text = @"交易";
        _dealLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _dealLabel.textColor = HEXCOLOR(0x36404e);
    }
    return _dealLabel;
}


- (TRRightChooseView *)rightChooseView {
    if (!_rightChooseView) {
        _rightChooseView = [[TRRightChooseView alloc] initWithFrame:CGRectMake(0, 0, 272, kWindowH)];
        _rightChooseView.dataArr = self.rightArray.copy;
        _rightChooseView.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        _rightChooseView.clickSure = ^(BOOL hasSelected, OTCFilterModel * _Nonnull filterModel) {
            @strongify(self);
//            self.filterButton.selected = hasSelected;
            self.filterModel = filterModel;
            if (self.delegate && [self.delegate respondsToSelector:@selector(headViewFilterWithFilerModel:)]) {
                [self.delegate headViewFilterWithFilerModel:self.filterModel];
            }
        };
    }
    return _rightChooseView;
}


@end
