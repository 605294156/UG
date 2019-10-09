//
//  UGCenterPopViewCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/24.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

@interface UGCenterPopViewCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *selecteBtn;
@property (copy, nonatomic) void(^cellClick)(UGCenterPopViewCell *viewCell);
- (void)cellClick:(void(^)(UGCenterPopViewCell *viewCell))block;
@end
