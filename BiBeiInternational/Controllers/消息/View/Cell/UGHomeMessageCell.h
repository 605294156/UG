//
//  UGHomeMessageCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/22.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGNotifyModel.h"

@interface UGHomeMessageCell : UGBaseTableViewCell

@property (nonatomic,assign) BOOL subMessageVC;

//动账、系统消息
- (void)updateWithModel:(UGNotifyModel *)model WithBage:(NSInteger)bage;

@end
