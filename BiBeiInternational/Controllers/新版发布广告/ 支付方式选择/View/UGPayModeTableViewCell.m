//
//  UGPayModeTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayModeTableViewCell.h"

@interface UGPayModeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;


@end

@implementation UGPayModeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UGAdPayWayModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    [model bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionNew task:^(UGAdPayWayModel *obj, NSDictionary *change) {
        self.rightImageView.hidden = !obj.selected;
    }];
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
}

@end
