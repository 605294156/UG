//
//  DepthHeader.h
//  CoinWorld
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepthHeader : UIView
+(DepthHeader *)instancetableHeardViewWithFrame:(CGRect)Rect;
@property (weak, nonatomic) IBOutlet UIButton *deepthBtn;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
