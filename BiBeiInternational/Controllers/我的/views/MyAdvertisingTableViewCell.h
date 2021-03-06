//
//  MyAdvertisingTableViewCell.h
//  CoinWorld
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdvertisingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *userName;//昵称
@property (weak, nonatomic) IBOutlet UILabel *payMode;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *advertisingType;//交易类型
@property (weak, nonatomic) IBOutlet UILabel *limitNum;//限额
@property (weak, nonatomic) IBOutlet UILabel *coinNum;//货币数量
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
