//
//  tradeCell.h
//  bit123
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *kindName;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
