//
//  OTCComplaintSelectedCountryCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "OTCComplaintSelectedCountryCell.h"

@implementation OTCComplaintSelectedCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -选择国家
- (IBAction)selectedCountry:(id)sender {
    if (self.tapBtnsHandle) {
        self.tapBtnsHandle();
    }
}
    
- (void)setModel:(OTCComplaintModel *)model {
    _model = model;
    self.countryLabel.text = model.title;
    self.countryFiled.placeholder = model.placeholder;
    self.countryFiled.text = model.value;
    @weakify(self);
    [model bk_addObserverForKeyPath:@"value" options:NSKeyValueObservingOptionNew task:^(OTCComplaintModel *obj, NSDictionary *change) {
        @strongify(self);
        self.countryFiled.text = obj.value;
    }];
}

@end
