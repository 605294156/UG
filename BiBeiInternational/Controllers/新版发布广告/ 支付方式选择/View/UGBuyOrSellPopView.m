//
//  UGBuyOrSellPopView.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/19.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBuyOrSellPopView.h"
#import "PopView.h"

@interface UGBuyOrSellPopView()

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *number;
@property(nonatomic, strong)NSString *rate;
@property(nonatomic, strong)NSString *real;
@property(copy, nonatomic) void(^clickHandle)(void);
@property(nonatomic, strong)PopView *popView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *titleImage;
@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UILabel *numberLab;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *rateLab;
@property (nonatomic,strong)UILabel *realLabel;
@property (nonatomic,strong)UILabel *realLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *tureBtn;
@property (nonatomic,assign)BOOL type;

-(instancetype)initWithTitle:(NSString *)title WithNumber:(NSString *)number WithRate:(NSString *)rate WithReal:(NSString *)real withType:(BOOL)type WithHandle:(void (^)(void))clickHandle;
@end

@implementation UGBuyOrSellPopView

+ (void)initWithTitle:(NSString *)title WithNumber:(NSString *)number WithRate:(NSString *)rate WithReal:(NSString *)real withType:(BOOL)type WithHandle:(void(^)(void))clickHandle{
    UGBuyOrSellPopView *centerView =[[UGBuyOrSellPopView alloc]initWithTitle:title WithNumber:number WithRate:rate WithReal:(NSString *)real withType:type WithHandle:^{
        if (clickHandle) {
            clickHandle();
        }
    }];
    PopView *popView =[PopView popSideContentView:centerView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.clickOutHidden = NO;
}

+(void)hidePopView{
    [PopView hidenPopView];
}

-(instancetype)initWithTitle:(NSString *)title WithNumber:(NSString *)number WithRate:(NSString *)rate WithReal:(NSString *)real withType:(BOOL)type WithHandle:(void (^)(void))clickHandle{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(UG_AutoSize(40), (kWindowH-UG_AutoSize(235))/2.0, kWindowW-2*UG_AutoSize(40), UG_AutoSize(235));
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 6;
            self.layer.masksToBounds = YES;
            self.title = title;
            self.number = number;
            self.rate = rate;
            self.real = real;
            self.type = type;
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    //标题
    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(30), UG_AutoSize(15), self.bounds.size.width-2*UG_AutoSize(30), UG_AutoSize(20))];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-self.titleLabel.frame.size.width)/2-UG_AutoSize(25), UG_AutoSize(15), self.titleLabel.frame.size.width,UG_AutoSize(20));
    [self addSubview:self.titleLabel];
    self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+UG_AutoSize(5), UG_AutoSize(15), UG_AutoSize(20), UG_AutoSize(20))];
    self.titleImage.image = [UIImage imageNamed:@"otc_titleImage"];
    [self addSubview:self.titleImage];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(10), CGRectGetMaxY(self.titleLabel.frame)+UG_AutoSize(15), self.bounds.size.width-2*UG_AutoSize(10), 0.46f)];
    line1.backgroundColor = [UIColor colorWithHexString:@"EDEDED"];
    [self addSubview:line1];
    
    //总数

    CGFloat width = self.bounds.size.width-UG_AutoSize(114)-2*UG_AutoSize(14);

    self.numberLab = [self returnLabel:YES WithFrame:CGRectMake(UG_AutoSize(14), CGRectGetMaxY(line1.frame)+UG_AutoSize(19), UG_AutoSize(100), UG_AutoSize(20)) Withtitle: self.type ? @"买入总数量" : @"卖出总数量"];
    self.numberLabel = [self returnLabel:NO WithFrame:CGRectMake(self.bounds.size.width-width-UG_AutoSize(14), CGRectGetMaxY(line1.frame)+UG_AutoSize(19), width, UG_AutoSize(20)) Withtitle:self.number];
    
    self.rateLab = [self returnLabel:YES WithFrame:CGRectMake(UG_AutoSize(14), CGRectGetMaxY(self.numberLab.frame)+UG_AutoSize(19), UG_AutoSize(100), UG_AutoSize(20)) Withtitle:@"手续费"];
    NSArray *array = [self.rate componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
    if (array.count>1) {
        NSString *strRate1 = array[0];
        NSString *strRate2 = array[1];
        NSString  *strAr = [NSString stringWithFormat:@"%@%@",strRate1,strRate2];
        self.rateLabel = [self returnLabel:NO WithFrame:CGRectMake(self.bounds.size.width-width-UG_AutoSize(14), CGRectGetMaxY(self.numberLab.frame)+UG_AutoSize(19), width, UG_AutoSize(20)) Withtitle:strAr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAr];
        NSRange range1 = [[str string] rangeOfString:strRate1];
        [str addAttribute:NSForegroundColorAttributeName value:UG_MainColor range:range1];
        NSRange range2 = [[str string] rangeOfString:strRate2];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:range2];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range2];
         self.rateLabel.attributedText = str;
    }else{
        self.rateLabel = [self returnLabel:NO WithFrame:CGRectMake(self.bounds.size.width-width-UG_AutoSize(14), CGRectGetMaxY(self.numberLab.frame)+UG_AutoSize(19), width, UG_AutoSize(20)) Withtitle:self.rate];
    }
    self.realLab = [self returnLabel:YES WithFrame:CGRectMake(UG_AutoSize(14), CGRectGetMaxY(self.rateLabel.frame)+UG_AutoSize(19), UG_AutoSize(100), UG_AutoSize(20)) Withtitle:self.type ? @"实际收入数量" : @"实际支出数量"];
    self.realLabel = [self returnLabel:NO WithFrame:CGRectMake(self.bounds.size.width-width-UG_AutoSize(14), CGRectGetMaxY(self.rateLabel.frame)+UG_AutoSize(19), width, UG_AutoSize(20)) Withtitle:self.real];
    self.realLabel.font = [UIFont systemFontOfSize:17];
    self.realLabel.textColor = [UIColor redColor];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(0), CGRectGetMaxY(self.realLab.frame)+UG_AutoSize(19), self.bounds.size.width-2*UG_AutoSize(0), 0.46f)];
    line2.backgroundColor = [UIColor colorWithHexString:@"EDEDED"];
    [self addSubview:line2];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(UG_AutoSize(0), CGRectGetMaxY(line2.frame), self.bounds.size.width/2.0, UG_AutoSize(48))];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:UG_MainColor forState:UIControlStateNormal];
//    self.cancelBtn.layer.borderColor = UG_MainColor.CGColor;
//    self.cancelBtn.layer.borderWidth = 1.0f;
//    self.cancelBtn.layer.cornerRadius = 4;
//    self.cancelBtn.layer.masksToBounds = YES;
    
    self.tureBtn.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-self.bounds.size.width/2.0, CGRectGetMaxY(line2.frame), self.bounds.size.width/2.0, UG_AutoSize(48))];
    [self.tureBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [self.tureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.tureBtn.backgroundColor = UG_MainColor;
//    self.tureBtn.layer.borderColor = UG_MainColor.CGColor;
//    self.tureBtn.layer.borderWidth = 1.0f;
//    self.tureBtn.layer.cornerRadius = 4;
//    self.tureBtn.layer.masksToBounds = YES;
    self.tureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.tureBtn addTarget:self action:@selector(tureBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.numberLab];
    [self addSubview:self.numberLabel];
    [self addSubview:self.rateLab];
    [self addSubview:self.rateLabel];
    [self addSubview:self.realLab];
    [self addSubview:self.realLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.tureBtn];
}

-(void)tureBtnClick{
    [PopView hidenPopView];
    if (self.clickHandle) {
        self.clickHandle();
    }
}

-(void)cancelBtnClick{
    [PopView hidenPopView];
}

-(UILabel *)returnLabel:(BOOL)isRight WithFrame:(CGRect)frame Withtitle:(NSString *)text {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor =isRight ? [UIColor colorWithHexString:@"999999"] : UG_MainColor;
    lab.text = text;
    lab.textAlignment =isRight ? NSTextAlignmentLeft : NSTextAlignmentRight;
    return lab;
}

@end
