//
//  UGSchduleViewCell.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGOrderWaitingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSchduleViewCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderSnoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic,copy) void(^payClick)(void);
@property (nonatomic,strong)UGOrderWaitingModel *model;
@end

NS_ASSUME_NONNULL_END
