//
//  UGPayWayTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayWayTableViewCell.h"


@interface UGPayWayTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recommentImage;

@end

@implementation UGPayWayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UGPayWayModel *)model {
    _model = model;
    self.headImageView.image = [UIImage imageNamed:model.imageName];
    self.titleLabel.text = model.title;
    self.recommendLabel.hidden = ![model.title isEqualToString:@"银行卡"];
    self.recommentImage.hidden = ![model.title isEqualToString:@"银行卡"];
    self.descLabel.text = model.desc;
    BOOL showArrow = self.isReleaseAd && ![model.desc containsString:@"未绑定"];
    self.arrowImageView.hidden = showArrow;
    if ([model.desc containsString:@"未绑定"]) {
        self.selectedImageView.hidden = YES;
        self.bind.hidden = ![model.title isEqualToString:@"银行卡"] ?NO:YES;
    }else{
        self.selectedImageView.hidden = ! model.selected;
        self.bind.hidden = YES;
    }
  
    @weakify(self);
    [model bk_addObserverForKeyPaths:@[@"desc", @"selected"] options:NSKeyValueObservingOptionNew task:^(UGPayWayModel *obj, NSString *keyPath, NSDictionary *change) {
        @strongify(self);
        if ([keyPath isEqualToString:@"desc"]) {
            self.descLabel.text = obj.desc;
            BOOL showArrow = self.isReleaseAd && ![obj.desc containsString:@"未绑定"];
            self.arrowImageView.hidden = showArrow;
        } else if ([keyPath isEqualToString:@"selected"]) {
            if ([model.desc containsString:@"未绑定"]) {
                self.selectedImageView.hidden = YES;
            }else{
                self.selectedImageView.hidden = ! obj.selected;
            }
        }
    }];
}

- (void) setIsLine:(BOOL)isLine{
    self.line.hidden = !isLine;
}

- (BOOL)useCustomStyle{
    return NO;
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
}

@end
