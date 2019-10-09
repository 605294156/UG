//
//  UGHomeBtnsCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
@protocol UGHomeBthsCellDegate <NSObject>

- (void)clickWithIndex:(int)index;

@end

@interface UGHomeBtnsCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *sacnBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiptBtn;
@property (weak, nonatomic) IBOutlet UIButton *walletRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *bTobBtnt;
@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@property (weak, nonatomic) IBOutlet UILabel *sanLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletrecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *bTobLabel;
@property (weak, nonatomic) IBOutlet UILabel *billLabel;
@property(nonatomic,weak)id<UGHomeBthsCellDegate>delegate;
-(void)reloadTitle;
@end
