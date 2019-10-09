//
//  UGTransferCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTransferCell.h"

@implementation UGTransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)click:(id)sender {
    if (self.click) {
        self.click();
    }
}

-(void)layoutSubviews{
    
}


@end
