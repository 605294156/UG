//
//  MyEntrustTableViewCell.h
//  CoinWorld
//
//  Created by iDog on 2018/4/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyEntrustTableViewCell;
@protocol MyEntrustTableViewCellDelegate <NSObject>
- (void)completeButtonIndex:(NSIndexPath *)index ;
@end
@interface MyEntrustTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payStatus;//买入卖出状态
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTitleWidth;
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;//时间标题
@property (weak, nonatomic) IBOutlet UILabel *timeData;//时间数据
@property (weak, nonatomic) IBOutlet UILabel *dealTitle;//成交总额标题
@property (weak, nonatomic) IBOutlet UILabel *dealData;//成交总额数据
@property (weak, nonatomic) IBOutlet UILabel *entrustPriceTitle;//委托价标题
@property (weak, nonatomic) IBOutlet UILabel *dealPerPriceTitle;//成交均价标题
@property (weak, nonatomic) IBOutlet UILabel *dealPerPriceData;//成交均价数据
@property (weak, nonatomic) IBOutlet UILabel *ntrustPriceData;//委托价数据
@property (weak, nonatomic) IBOutlet UILabel *entrustNumTitle;//委托量标题
@property (weak, nonatomic) IBOutlet UILabel *entrustNumData;//委托量数据
@property (weak, nonatomic) IBOutlet UILabel *dealNumTitle;//成交量标题
@property (weak, nonatomic) IBOutlet UILabel *dealNumData;//成交量数据
@property (weak, nonatomic) IBOutlet UIButton *statusButton;//状态按钮
@property(nonatomic,strong)NSIndexPath *index;
@property (nonatomic,weak) id<MyEntrustTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
