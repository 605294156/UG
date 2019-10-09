//
//  UGOpenReceivePopView.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGOpenReceivePopView.h"
#import "PopView.h"
#import "UGNewGuidStatusManager.h"

@interface UGOpenReceivePopView()
@property (copy, nonatomic) void(^clickHandle)(BOOL isOpen);
@property (nonatomic,strong)UIImageView *imag;
@property (nonatomic,strong)UIImageView *imagBell;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *desTitle;
@property (nonatomic,strong)UIButton *openBtn;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIView *bacView;
- (instancetype)initWithClickItemHandle:(void(^)(BOOL isOpen))clickHandle;

@end


@implementation UGOpenReceivePopView

+ (void)showOpenPopViewClickItemHandle:(void(^)(BOOL isOpen))clickHandle;{
    UGOpenReceivePopView *centerView =[[UGOpenReceivePopView alloc] initWithClickItemHandle:^(BOOL isOpen) {
        if (clickHandle) {
            clickHandle(isOpen);
        }
    }];
    PopView *popView =[PopView popSideContentView:centerView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.clickOutHidden = NO;
    popView.didRemovedFromeSuperView = ^{
        [centerView removeFromSuperview];
    };
}

+(void)hidenPopView{
    [PopView hidenPopView];
}

- (instancetype)initWithClickItemHandle:(void(^)(BOOL isOpen))clickHandle{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake((kWindowW-UG_AutoSize(280))/2.0, (kWindowH-UG_AutoSize(290))/2.0, UG_AutoSize(280), UG_AutoSize(290));
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 4;
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.imag];
    
    [self addSubview:self.bacView];
    
    [self addSubview:self.imagBell];
   
    [self.bacView addSubview:self.title];
    
    [self.bacView addSubview:self.desTitle];
    
    [self addSubview:self.openBtn];
    
   [self addSubview:self.closeBtn];
}

-(void)open{
    if (self.clickHandle) {
        self.clickHandle(YES);
    }
}

-(UIImageView *)imag{
    if (!_imag) {
        _imag = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, UG_AutoSize(127))];
        _imag.userInteractionEnabled = YES;
        _imag.image = [UIImage imageNamed:@"open_pic_back"];
    }
    return _imag;
}

-(UIView *)bacView{
    if (!_bacView) {
        _bacView = [[UIView alloc] initWithFrame:CGRectMake(UG_AutoSize(25), UG_AutoSize(85), self.frame.size.width-2*UG_AutoSize(25), UG_AutoSize(97))];
        _bacView.backgroundColor = [UIColor whiteColor];
        _bacView.layer.cornerRadius = 4;
        _bacView.layer.masksToBounds = YES;
        _bacView.userInteractionEnabled = YES;
    }
    return _bacView;
}

-(UIImageView *)imagBell{
    if (!_imagBell) {
        _imagBell = [[UIImageView  alloc] initWithFrame:CGRectMake((self.frame.size.width-UG_AutoSize(90))/2.0, UG_AutoSize(20), UG_AutoSize(90), UG_AutoSize(90))];
        _imagBell.userInteractionEnabled = YES;
        _imagBell.image = [UIImage imageNamed:@"open_Receive_small_bell"];
    }
    return _imagBell;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, UG_AutoSize(28), self.frame.size.width-2*UG_AutoSize(25), UG_AutoSize(25))];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:18];
        _title.textColor = UG_MainColor;
        _title.text = @"开启接单";
    }
    return _title;
}

-(UILabel *)desTitle{
    if (!_desTitle) {
        _desTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, UG_AutoSize(64), self.frame.size.width-2*UG_AutoSize(25), UG_AutoSize(20))];
        _desTitle.textAlignment = NSTextAlignmentCenter;
        _desTitle.font = [UIFont systemFontOfSize:11];
        _desTitle.textColor = [UIColor colorWithHexString:@"666666"];
        _desTitle.text = @"接收平台为您匹配合适的出售订单";
    }
    return _desTitle;
}

-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] initWithFrame:CGRectMake(UG_AutoSize(34), CGRectGetMaxY(_bacView.frame)+UG_AutoSize(10), self.frame.size.width-2*UG_AutoSize(34), UG_AutoSize(36))];
        [_openBtn setBackgroundImage:[UIImage imageNamed:@"open_pop_btn"] forState:UIControlStateNormal];
        _openBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_openBtn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        [_openBtn setTitle:@"开启" forState:UIControlStateNormal];
    }
    return _openBtn;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(UG_AutoSize(34), CGRectGetMaxY(_openBtn.frame)+UG_AutoSize(8), self.frame.size.width-2*UG_AutoSize(34), UG_AutoSize(36))];
        [_closeBtn setTitle:@"暂不开启" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UG_MainColor forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_closeBtn addTarget:self action:@selector(closePopView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(void)closePopView{
    if (self.clickHandle) {
        self.clickHandle(NO);
    }
}

@end
