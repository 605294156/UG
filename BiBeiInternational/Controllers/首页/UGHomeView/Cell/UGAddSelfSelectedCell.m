//
//  UGAddSelfSelectedCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/25.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGAddSelfSelectedCell.h"
#import "AppDelegate.h"
#import "symbolModel.h"

@implementation UGAddSelfSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectedBtnCick:(id)sender {
    if (self.clickBtn) {
        self.clickBtn(sender);
    }
}

-(void)cellClickBtn:(void (^)(id))block{
    _clickBtn = block;
}
-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)configDataWithModel:(symbolModel*)model{
    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
    NSString*baseSymbol=[array firstObject];
    NSString*coinSymbol=[array lastObject];
    self.titleLabel.text=baseSymbol;
    self.subTitleLabel.text=[NSString stringWithFormat:@"/%@",coinSymbol];
    self.changenumLabel.text =[model.closeStr ug_amountFormat];
    NSString *cnyStr =[NSString stringWithFormat:@"%f",model.close*model.baseUsdRate*[((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate doubleValue]];
    self.cnyLabel.text=[NSString stringWithFormat:@"¥ %@",[cnyStr ug_amountFormat]];//计算人民币
    self.percenLabel.text =[NSString stringWithFormat:@"%.2f%%", model.chg*100];
    self.percenLabel.layer.cornerRadius= 2;
    self.percenLabel.layer.masksToBounds= YES;
     self.hournumLabel.text=[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"hourvol"),[[NSString stringWithFormat:@"%f",model.volume] ug_amountFormat]];
    if (model.chg >=0) {
        self.changenumLabel.textColor=[UIColor colorWithHexString:Color_GreenX];
        self.percenLabel.backgroundColor=[UIColor colorWithHexString:Color_GreenX];
    }else{
        self.changenumLabel.textColor=[UIColor colorWithHexString:Color_RedX];
        self.percenLabel.backgroundColor=[UIColor colorWithHexString:Color_RedX];
    }
}

@end
