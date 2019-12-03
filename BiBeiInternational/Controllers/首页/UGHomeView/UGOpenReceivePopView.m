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

/**首页开启接单弹框view*/
@interface UGOpenReceivePopView()
@property (copy, nonatomic) void(^clickHandle)(BOOL isOpen);
@property (nonatomic,strong)UIImageView *imag;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *desTitle;
@property (nonatomic,strong)UIButton *openBtn;
@property (nonatomic,strong)UIButton *closeBtn;
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
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
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
        CGRect frame = CGRectMake((kWindowW-UG_AutoSize(280))/2.0, (kWindowH-UG_AutoSize(347))/2.0, UG_AutoSize(280), UG_AutoSize(347));
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.imag];
    [self addSubview:self.title];
    [self addSubview:self.desTitle];
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
        _imag = [[UIImageView  alloc] initWithFrame:CGRectMake(20.0, 93.0, self.frame.size.width-40.0, 140.0)];
        _imag.userInteractionEnabled = YES;
        _imag.image = [UIImage imageNamed:@"home_popBackImg"];
    }
    return _imag;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, self.frame.size.width, 20)];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textColor = [UIColor colorWithHexString:@"333333"];;
        _title.text = @"开启接单";
    }
    return _title;
}

-(UILabel *)desTitle{
    if (!_desTitle) {
        _desTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, self.frame.size.width, 16)];
        _desTitle.textAlignment = NSTextAlignmentCenter;
        _desTitle.font = [UIFont systemFontOfSize:15];
        _desTitle.textColor = [UIColor colorWithHexString:@"999999"];
        _desTitle.text = @"接收平台为您匹配合适的出售订单";
    }
    return _desTitle;
}

-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] initWithFrame:CGRectMake(14.0, CGRectGetMaxY(_imag.frame)+23.0, self.frame.size.width-2*14.0, 44.0)];
        [_openBtn setBackgroundColor:[UIColor colorWithHexString:@"6684c7"]];
        _openBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_openBtn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        [_openBtn setTitle:@"立即开启" forState:UIControlStateNormal];
    }
    return _openBtn;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(14.0, CGRectGetMaxY(_openBtn.frame)+UG_AutoSize(3), self.frame.size.width-2*14.0, UG_AutoSize(36))];
        [_closeBtn setTitle:@"暂不开启" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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
