//
//  marketCell.m
//  bit123
//
//  Created by sunliang on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "marketCell.h"
#import "AppDelegate.h"
@implementation marketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configDataWithModel:(symbolModel*)model withtype:(int)type withIndex:(int)index{

    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
  
    self.nameLabel.text=[array firstObject];
    self.baseLabel.text=[NSString stringWithFormat:@"/%@",[array lastObject]];
    self.moneyLabel.text=[NSString stringWithFormat:@"%@",model.closeStr];
    if (((AppDelegate*)[UIApplication sharedApplication].delegate).isShowCNY) {
        self.cnyLabel.text=[NSString stringWithFormat:@"¥ %.2f",model.close*model.baseUsdRate*[((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate doubleValue]];
    }else{
         self.cnyLabel.text=[NSString stringWithFormat:@"$ %.2f",model.close*model.baseUsdRate];
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];
    self.tradeNumbel.text=[NSString stringWithFormat:@"%@ %.2f",LocalizationKey(@"hourvol"),model.volume];
   
    if (model.change <0) {
        self.moneyLabel.textColor=RedColor;
        self.changeLabel.backgroundColor=RedColor;
    }else{
        self.moneyLabel.textColor=GreenColor;
        self.changeLabel.backgroundColor=GreenColor;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClick:(UIButton *)sender {
    
    
}

@end
