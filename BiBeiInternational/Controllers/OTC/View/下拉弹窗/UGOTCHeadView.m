//
//  UGOTCHeadView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCHeadView.h"
#import "UGButton.h"
#import "TRRightChooseView.h"
#import "PopView.h"

@interface UGOTCHeadView ()

@property (nonatomic, strong) UGButton *releaseButton;//发布广告按钮
@property (nonatomic, strong) UGButton *filterButton;//筛选按钮
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
        self.buttonTitle = @"我要出售";
        self.rightArray = [MoreChooseDataModel mj_objectArrayWithFilename:@"XX.plist"];
        [self setupButtons];
    }
    return self;
}

#pragma mark - SetView Method

- (void)setupButtons {
    
    [self addSubview:self.filterButton];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(8);
        make.leading.mas_equalTo(self).mas_offset(25);
        make.size.mas_equalTo(CGSizeMake(88, 34));
    }];

    [self addSubview:self.releaseButton];
    [self.releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).mas_offset(-25);
        make.top.mas_equalTo(self.filterButton.mas_top);
        make.height.mas_equalTo(self.filterButton.mas_height);
        make.leading.mas_equalTo(self.filterButton.mas_trailing).mas_offset(25);
    }];
    
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

- (void)clickFilter:(UGButton *)sender {
    PopView *popView = [PopView popSideContentView:self.rightChooseView direct:PopViewDirection_SlideFromLeft];
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
    [self.releaseButton setTitle:buttonTitle forState:UIControlStateNormal];
}


#pragma mark - Getter Method

- (UGButton *)releaseButton {
    if (!_releaseButton) {
        _releaseButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleWhite];
        [_releaseButton setTitle:self.buttonTitle forState:UIControlStateNormal];
        [_releaseButton addTarget:self action:@selector(clickRelease:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseButton;
}

- (UGButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleWhite];
        [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}


- (TRRightChooseView *)rightChooseView {
    if (!_rightChooseView) {
        _rightChooseView = [[TRRightChooseView alloc] initWithFrame:CGRectMake(0, 0, 272, kWindowH)];
        _rightChooseView.dataArr = self.rightArray.copy;
        _rightChooseView.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        _rightChooseView.clickSure = ^(BOOL hasSelected, OTCFilterModel * _Nonnull filterModel) {
            @strongify(self);
            self.filterButton.selected = hasSelected;
            self.filterModel = filterModel;
            if (self.delegate && [self.delegate respondsToSelector:@selector(headViewFilterWithFilerModel:)]) {
                [self.delegate headViewFilterWithFilerModel:self.filterModel];
            }
        };
    }
    return _rightChooseView;
}


@end
