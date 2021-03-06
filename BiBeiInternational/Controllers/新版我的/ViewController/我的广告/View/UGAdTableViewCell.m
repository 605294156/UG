//
//  UGAdTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdTableViewCell.h"
#import "UGPayMethodView.h"

@interface UGAdTableViewCell ()

@property (weak, nonatomic) IBOutlet UGPayMethodView *payMethodView;//支付方式
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//出售BTC
@property (weak, nonatomic) IBOutlet UILabel *numLabel;//deal_amount 交易中的数量
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;//price单价
@property (weak, nonatomic) IBOutlet UIView *buttonsConainer;//底部按钮容器View
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//交易状态
@property (weak, nonatomic) IBOutlet UILabel *adIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;//交易状态
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMethodViewWidth;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StatusLabelRight;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImg;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adIDLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuNumLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomsTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adIDTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sl_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cs_top;

@end

@implementation UGAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.shadowImg.layer.masksToBounds = NO;
//    self.shadowImg.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.shadowImg.layer.shadowOffset = CGSizeZero;
//    self.shadowImg.layer.shadowOpacity = 0.1f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setShowShadow:(BOOL)showShadow{
    _showShadow = showShadow;
    self.shadowImg.hidden = !showShadow;
    if (showShadow) {
        self.adIDLeading.constant = 23.f;
        self.yuNumLeading.constant = 23.f;
        self.buttomsTrailing.constant = 25.f;
        self.payViewBottom.constant = 83.f;
        self.lineLeading.constant = 10.f;
        self.lineTrailing.constant = 10.f;
        self.adIDTop.constant = 27.f;
        self.sl_top.constant = 31.f;
        self.cs_top.constant = 7.f;
    }
}

-(void)setIsNotify:(BOOL)isNotify{
    _isNotify = isNotify;
    self.buttonsConainer.hidden = isNotify;
    self.rightArrow.hidden = isNotify;
    if (isNotify) {
        self.StatusLabelRight.constant = self.showShadow ? 25 : 15;
    }
}

- (void)setModel:(UGOTCAdModel *)model {
    _model = model;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    //广告ID
    self.adIDLabel.text = [NSString stringWithFormat:@"交易ID：%@",model.ID];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",[model.advertiseType isEqualToString:@"0"] ? @"购买" : @"出售", model.coinName];
//    //总数量
    self.numLabel.text = [NSString stringWithFormat:@"%@数量：%@ %@",[model.advertiseType isEqualToString:@"0"] ? @"购买" : @"出售",[model.number ug_amountFormat],model.coinName];
//    self.numLabel.text = [NSString stringWithFormat:@"剩余数量：%@ %@",[model.remainAmount ug_amountFormat], model.coinName];
    //剩余量
//    self.cnyLabel.text = [NSString stringWithFormat:@"剩余数量  %@ %@",[model.remainAmount ug_amountFormat], model.coinName];
    NSString *Str =  [NSString stringWithFormat:@"剩余数量:  %@ %@",[model.remainAmount ug_amountFormat], model.coinName];
    NSString *rangeStr =  @"剩余数量";
    self.cnyLabel.attributedText = [self attributedStringWith:Str WithRangeStr:rangeStr WithColor:[UIColor blackColor]];
    //支付方式
    self.payMethodView.payWays = [model.payMode componentsSeparatedByString:@","];
    self.payMethodViewWidth.constant = self.payMethodView.viewWidth;
    
    //底部按钮
    [self setupButtonsWithStatus:model.status withOffShelvesType:model.offShelvesType];
    
    //监听状态变化
    @weakify(self);
    [model bk_addObserverForKeyPath:@"status" options:NSKeyValueObservingOptionNew task:^(UGOTCAdModel *obj, NSDictionary *change) {
        @strongify(self);
        //底部按钮和上架状态
        [self setupButtonsWithStatus:obj.status withOffShelvesType:obj.offShelvesType];
        //支付方式
        if (model.payWays.count > 0) {
            self.payMethodView.payWays = model.payWays;
            self.payMethodViewWidth.constant = self.payMethodView.viewWidth;
        }
        //总数量
//        self.numLabel.text = [NSString stringWithFormat:@"数量：%@",model.number];
        self.numLabel.text = [NSString stringWithFormat:@"总数量：%@ %@",[model.remainAmount ug_amountFormat], model.coinName];
        //剩余量
//        self.cnyLabel.text = [NSString stringWithFormat:@"剩余数量 %@ %@",model.remainAmount, model.coinName];
        NSString *Str =  [NSString stringWithFormat:@"剩余数量  %@ %@",[model.remainAmount ug_amountFormat], model.coinName];
        NSString *rangeStr =  @"剩余数量";
        self.cnyLabel.attributedText = [self attributedStringWith:Str WithRangeStr:rangeStr WithColor:[UIColor blackColor]];
    }];
    
}

-(NSMutableAttributedString *)attributedStringWith:(NSString *)attributedString WithRangeStr:(NSString *)rangeStr WithColor:(UIColor *)color{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    NSRange range1 = [[str string] rangeOfString:rangeStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    return str;
}

//底部按钮
- (void)setupButtonsWithStatus:(NSString *)status withOffShelvesType:(NSString *)offShelvesType {
    //上架中
    BOOL saleIng = [status isEqualToString:@"0"];
    //交易状态
    self.statusLabel.text =  saleIng ? @"已上架" : @"已下架";
    self.statusImageView.image = saleIng ? [UIImage imageNamed:@"mine_putaway"] : [UIImage imageNamed:@"mine_soldout"];
    //先移除
    for (UIView *view in self.buttonsConainer.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
//    NSArray *titles = saleIng ? @[@"下架",@"分享"]  :   [offShelvesType isEqualToString:@"1"] ? @[@"删除"] : @[@"删除", @"修改", @"上架"];
     NSArray *titles = saleIng ? @[@"下架"]  :   [offShelvesType isEqualToString:@"1"] ? @[@"删除"] : @[@"删除", @"修改", @"上架"];
    
    UIView *lastView = self.buttonsConainer;

    for (int i = 0; i < titles.count; i ++) {
        BOOL firstView = [lastView isEqual:self.buttonsConainer];
        UIButton *button = [self creatButtonwithTitle:titles[i]];
        [self.buttonsConainer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.buttonsConainer.mas_top);
            make.height.mas_equalTo(self.buttonsConainer.mas_height);
            make.width.mas_equalTo(40.0f);
            make.trailing.mas_equalTo(firstView ? lastView.mas_trailing : lastView.mas_leading).mas_offset( firstView ? 0 : -10 );
        }];
        lastView = button;
    }
    [self.buttonsConainer layoutIfNeeded];
}


- (UIButton *)creatButtonwithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    button.layer.borderWidth = 1.0f;
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 2.0f;
    button.layer.borderColor = HEXCOLOR(0x6684c7).CGColor;
    [button setTitleColor:HEXCOLOR(0x6684c7) forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0x6684c7) forState:UIControlStateHighlighted];
    return button;
}

- (void)clickButton:(UIButton *)btn {
    if (self.clickButtonHandle) {
        self.clickButtonHandle(btn.titleLabel.text, self.model);
    }
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
}

- (BOOL)useCustomStyle{
    return NO;
}

@end
