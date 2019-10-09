//
//  BuyCoinsDetail2TableViewCell.h
//  CoinWorld
//
//  Created by iDog on 2018/2/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInputTextField.h"

@class BuyCoinsDetail2TableViewCell;

@protocol BuyCoinsDetail2TableViewCellDelegate <NSObject>
- (void)textFieldTag:(NSInteger)index TextFieldString: (NSString *)textString;
@end

@interface BuyCoinsDetail2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipstring; //提示语

@property (weak, nonatomic) IBOutlet UILabel *coinType1;//第一种货币类型
@property (weak, nonatomic) IBOutlet UserInputTextField *coinType1Num;//第一种货币类型数量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coinType1Width;//第一种货币宽度
@property (weak, nonatomic) IBOutlet UILabel *coinType2;//第2种货币类型
@property (weak, nonatomic) IBOutlet UserInputTextField *coinType2Num;//第2种货币类型数量
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//交易提醒内容
@property (weak, nonatomic) IBOutlet UILabel *tradeTipLabel;
@property (nonatomic,weak) id<BuyCoinsDetail2TableViewCellDelegate> delegate;

@end
