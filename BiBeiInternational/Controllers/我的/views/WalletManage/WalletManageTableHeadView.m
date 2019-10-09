//
//  WalletManageTableHeadView.m
//  CoinWorld
//
//  Created by iDog on 2018/4/12.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "WalletManageTableHeadView.h"

@implementation WalletManageTableHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.searchBar.placeholder = LocalizationKey(@"searchAssets");
    self.selectBtnLabel.text = LocalizationKey(@"hidden0Currency");

}
-(WalletManageTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WalletManageTableHeadView" owner:nil options:nil];
    WalletManageTableHeadView *tableView=[nibView objectAtIndex:0];
    tableView.frame=Rect;
    return tableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
