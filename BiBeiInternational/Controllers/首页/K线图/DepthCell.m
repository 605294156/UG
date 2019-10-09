//
//  DepthCell.m
//  CoinWorld
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "DepthCell.h"
#import "UIColor+Y_StockChart.h"

@implementation DepthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor backgroundColor];
    self.buyView.backgroundColor=[ToolUtil colorWithHexString:@"2c4137"];
    self.SellView.backgroundColor=[ToolUtil colorWithHexString:@"46282a"];
  
    // Initialization code
}
-(void)config:(plateModel*)buymodel withmodel:(plateModel*)Sellmodel withindexth:(NSIndexPath*)indexpath{
    if (buymodel.amount<=0) {
        self.BuyIndex.text=[NSString stringWithFormat:@"%ld",indexpath.row];
        self.buyNum.text=@"--";
        self.BuyPrice.text=@"--";
    }else{
        self.BuyIndex.text=[NSString stringWithFormat:@"%ld",indexpath.row];
        self.buyNum.text=[NSString stringWithFormat:@"%@",buymodel.amountStr];
        self.BuyPrice.text=[NSString stringWithFormat:@"%@",buymodel.priceStr];
        
    }
    if (Sellmodel.amount<=0) {
        self.SellPrice.text=@"--";
        self.SellNum.text=@"--";
        self.SellIndex.text=[NSString stringWithFormat:@"%ld",indexpath.row];
    }else{
        self.SellPrice.text=[NSString stringWithFormat:@"%@",Sellmodel.priceStr];
        self.SellNum.text=[NSString stringWithFormat:@"%@",Sellmodel.amountStr];
        self.SellIndex.text=[NSString stringWithFormat:@"%ld",indexpath.row];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
