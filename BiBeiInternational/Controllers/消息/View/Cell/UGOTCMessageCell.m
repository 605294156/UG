//
//  UGOTCMessageCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCMessageCell.h"
#import "UGRemotemessageHandle.h"

@interface UGOTCMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;//背景图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//订单标题 例如：交易订单-出售 、我的发布-出售
@property (weak, nonatomic) IBOutlet UILabel *orderCreatTime;//订单时间
@property (weak, nonatomic) IBOutlet UILabel *coinAmountLabel;//数字币金额
@property (weak, nonatomic) IBOutlet UILabel *advertiseIDLabel;//交易ID
@property (weak, nonatomic) IBOutlet UILabel *idVlaueLabel;//交易ID

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;//订单账号
@property (weak, nonatomic) IBOutlet UILabel *transctionLabel;//交易账号
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//交易金额
@property (weak, nonatomic) IBOutlet UILabel *handlingFreeLabel;//手续费
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idLabelConstraint;//交易ID高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;//订单号和交易ID的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderSnHeight;//订单号高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderAccountTop;//订单账号和订单号之间的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderAccountHeight;//交易账号高度
@property (weak, nonatomic) IBOutlet UILabel *total;
@end

@implementation UGOTCMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView sendSubviewToBack:self.bgImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UGNotifyModel *)model {
    _model = model;
    UGOTCOrderMeeageModel *ordeMessagerModel = (UGOTCOrderMeeageModel*)model.data;
    //是OTC订单 还是交易
    BOOL isOrder = [ordeMessagerModel.otcMessageType isEqualToString:@"OTC_ORDER_MSG"];
    
    //隐藏 交易ID
    self.idLabelConstraint.constant = isOrder ? 0.0f : 16.0f;
    self.topConstraint.constant = isOrder ? 10.0f : 0.0f;
    self.orderSnHeight.constant = isOrder ? 16.0f : 0.0f;
    self.orderAccountHeight.constant = isOrder ? 16.0f : 0.0f;
    self.orderAccountTop.constant = isOrder ? 10.0f : 0.0f;
    
    //标题
    self.titleLabel.attributedText = [self convertTitleToAttributedStringWithTitle:model.title];
    
    self.orderCreatTime.text = [UG_MethodsTool getFriendyWithStartTime:ordeMessagerModel.createTime];
    
    self.coinAmountLabel.text = [NSString stringWithFormat:@"%@ %@",ordeMessagerModel.total, ordeMessagerModel.coinUnit];
    
    self.coinAmountLabel.textColor = [self.coinAmountLabel.text containsString:@"-"] ? [UIColor colorWithHexString:Color_RedX] : [UIColor colorWithHexString:Color_GreenX];

    self.statusLabel.text = ordeMessagerModel.subTitle;
    
    self.idVlaueLabel.text = ordeMessagerModel.advertiseId;
    
    self.orderSnLabel.text = ordeMessagerModel.orderSn;
    
    self.transctionLabel.text = ordeMessagerModel.others;
    
    if ([ordeMessagerModel.restitutionAmount doubleValue] == 0) {
        self.totalLabel.text = [NSString stringWithFormat:@"%@ %@", ordeMessagerModel.amount, ordeMessagerModel.coinUnit];
        self.total.text = @"交易金额";
    }else{
        self.totalLabel.text = [NSString stringWithFormat:@"%@ %@", ordeMessagerModel.restitutionAmount, ordeMessagerModel.coinUnit];
        self.total.text = @"交易返还";
    }
    self.handlingFreeLabel.text = [NSString stringWithFormat:@"%@ %@", ordeMessagerModel.commission, ordeMessagerModel.coinUnit];
    
}

- (NSAttributedString *)convertTitleToAttributedStringWithTitle:(NSString *)title {
    NSString *suffix = [title componentsSeparatedByString:@"-"].lastObject;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSRangeFromString(title)];
    NSRange range = [title rangeOfString:suffix];
    [attrString addAttribute:NSForegroundColorAttributeName value:[suffix containsString:@"出售"] ? [UIColor colorWithHexString:Color_RedX] : [UIColor colorWithHexString:Color_GreenX]  range:range];
    return attrString;
}

- (IBAction)clickDetails:(UIButton *)sender {
    if (self.clickDetailedHandle) {
        self.clickDetailedHandle(self.model);
    }
}


- (void)dealloc {
    
}

@end
