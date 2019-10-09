//
//  KlineHeaderCell.m
//  CoinWorld
//
//  Created by sunliang on 2018/5/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "KlineHeaderCell.h"
#import "AppDelegate.h"
@implementation KlineHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Hlabel.text=LocalizationKey(@"highest");
    self.Llabel.text=LocalizationKey(@"minimumest");
    self.Alabel.text=LocalizationKey(@"24H");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configModel:(symbolModel*)model{
    self.nowPrice.text=[NSString stringWithFormat:@"%@",model.closeStr];
     int length = (int)((AppDelegate*)[UIApplication sharedApplication].delegate).precisionNum;
    NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
    self.CNYLabel.text=[NSString stringWithFormat:@"≈%.2f 元",model.close *model.baseUsdRate *[cnyRate doubleValue]];
    self.hightPrice.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:model.high withlimit:length]];
    self.LowPrice.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:model.low withlimit:length]];
    self.numberLabel.text=[NSString stringWithFormat:@"%.4f",model.volume];
    if (model.change <0) {
        self.changeLabel.textColor=RedColor;
        self.nowPrice.textColor=RedColor;
        self.changeLabel.text= [NSString stringWithFormat:@"%@%.2f%%",LocalizationKey(@"increase"), model.chg*100];
    }else{
        self.changeLabel.textColor=GreenColor;
        self.nowPrice.textColor=GreenColor;
        self.changeLabel.text= [NSString stringWithFormat:@"%@%.2f%%", LocalizationKey(@"increase"),model.chg*100];
    }
    
}
@end
