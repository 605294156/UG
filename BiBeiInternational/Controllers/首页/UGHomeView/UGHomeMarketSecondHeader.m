//
//  UGHomeMarketSecondHeader.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMarketSecondHeader.h"

@interface UGHomeMarketSecondHeader()
@property(nonatomic,strong)UILabel *marketLabel;
@property(nonatomic,strong)UIView *backsView;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)UIButton *curentBtn;
@property(nonatomic,strong)UIImageView *arrowImg;
@property(nonatomic,strong)NSMutableArray *btnArry;
@end

@implementation UGHomeMarketSecondHeader

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.marketLabel];
        [self addSubview:self.backsView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setIndex:(NSInteger)index{
    [self.btnArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
         if (index == idx) {
            btn.selected = YES;
        }else
            btn.selected = NO;
    }];
}

-(NSMutableArray *)btnArry{
    if (!_btnArry) {
        _btnArry = [[NSMutableArray alloc] init];
    }
    return _btnArry;
}

-(void)tapAction:(UITapGestureRecognizer *)gester{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

-(void)initUI{
    if (self.backsView) {
        for (UIView * view in self.backsView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (UG_CheckArrayIsEmpty(self.titlesArray) || self.titlesArray.count<=0)
        return;
    [self.backsView addSubview:self.lineLabel];
    [self.backsView addSubview:self.arrowImg];
    [self.btnArry removeAllObjects];
    float x = UG_AutoSize(8);
    for (int i = 0; i<self.titlesArray.count; i++) {
        NSString *str = self.titlesArray[i];
        if (![NSString stringIsNull:str]) {
            CGSize size = [NSString stringSize:str withFont:UG_AutoFont(12)];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x,UG_AutoSize(0) , size.width+UG_AutoSize(15), self.bounds.size.height-UG_AutoSize(38))];
            [btn setTitle:str forState:UIControlStateNormal];
            btn.titleLabel.font =UG_AutoFont(14);
            btn.tag = 1000+i;
            [btn setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"108CE5"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            x += size.width+UG_AutoSize(15);
            [self.backsView addSubview:btn];
            [self.btnArry addObject:btn];
        }
    }
}

-(void)btnClick:(UIButton *)sender{
//    if ((int)(sender.tag-1000) == self.index) {
//        return;
//    }
//    if (sender == self.curentBtn)
//        return;
//    sender.selected = !sender.selected;
//    self.curentBtn.selected = NO;
//    self.curentBtn = sender;
    if (self.btnClickBlock) {
        self.btnClickBlock(sender.tag-1000);
    }
}

- (void)btnClickBlock:(void(^)(NSInteger index))block{
    self.btnClickBlock = block;
}

- (void)clickBlock:(void(^)(id obj))block{
    self.clickBlock = block;
}

-(UILabel *)marketLabel{
    if (!_marketLabel) {
        _marketLabel = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(14 ), UG_AutoSize(0),kWindowW-2*UG_AutoSize(14), UG_AutoSize(38))];
        _marketLabel.backgroundColor = [UIColor clearColor];
        _marketLabel.font = UG_AutoFont(14);
        _marketLabel.textAlignment = NSTextAlignmentCenter;
        _marketLabel.text = @"行情";
        _marketLabel.textColor = [UIColor colorWithHexString:@"717171"];
    }
    return _marketLabel;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(14), self.bounds.size.height-UG_AutoSize(38)-0.5f,self.bounds.size.width-2*UG_AutoSize(14), 0.5f)];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    }
    return _lineLabel;
}

-(UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-UG_AutoSize(27), (self.bounds.size.height-UG_AutoSize(38)-UG_AutoSize(13))/2, UG_AutoSize(8), UG_AutoSize(13))];
        _arrowImg.userInteractionEnabled = YES;
        _arrowImg.image = [UIImage imageNamed:@"more_icon.png"];
    }
    return _arrowImg;
}

-(UIView *)backsView{
    if (!_backsView) {
        _backsView = [[UIView alloc] initWithFrame:CGRectMake(0, UG_AutoSize(38), self.bounds.size.width,self.bounds.size.height-UG_AutoSize(38))];
        _backsView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_backsView addGestureRecognizer:aTap];
    }
    return _backsView;
}

-(void)setTitlesArray:(NSMutableArray *)titlesArray{
    _titlesArray = titlesArray;
    [self initUI];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
