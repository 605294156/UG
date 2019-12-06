//
//  Advertising1TableViewCell.h
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLimitedTextField.h"

@class Advertising1TableViewCell;

@protocol Advertising1TableViewCellDelegate <NSObject>

- (void)textFieldIndex:(NSIndexPath *)index TextFieldString: (NSString *)textString;

- (void)textFieldIndex:(NSIndexPath *)index TextChangeString: (NSString *)textString;

@end

@interface Advertising1TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *centerTextFileld;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (nonatomic,weak) id<Advertising1TableViewCellDelegate> delegate;
@property(nonatomic,strong)NSIndexPath *index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpace;


@end
