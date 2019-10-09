//
//  MineTableHeadView.m
//  ATC
//
//  Created by iDog on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MineTableHeadView.h"

@implementation MineTableHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(MineTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MineTableHeadView" owner:nil options:nil];
    MineTableHeadView *tableView=[nibView objectAtIndex:0];
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
