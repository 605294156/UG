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
@property(nonatomic,weak)id<UGHomeBthsCellDegate>delegate;
@end
