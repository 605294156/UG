//
//  UGRatePopViewCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGRatePopViewCell.h"

@interface UGRatePopViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImag;
@property (weak, nonatomic) IBOutlet UILabel *rateLable;
@property (weak, nonatomic) IBOutlet UILabel *shareBounsLabel;
@end

@implementation UGRatePopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(UGSlaveRateModel *)model{
    _model = model;
    self.selectImag.image = [UIImage  imageNamed: model.selected ? @"Rate_Select" : @"Rate_Unselect"];
//    self.rateLable.textColor = model.selected ? UG_MainColor : [UIColor colorWithHexString:@"666666"];
//    self.shareBounsLabel.textColor = model.selected ? UG_MainColor : [UIColor colorWithHexString:@"666666"];
    self.rateLable.text =[NSString stringWithFormat:@"%@‰ / %@‰",model.nextRate,model.myDividend];
//    self.shareBounsLabel.text = [NSString stringWithFormat:@"%@‰",model.myDividend];
//    self.backgroundColor = model.selected ? [UIColor colorWithHexString:@"F5F5F5"] : [UIColor whiteColor];
//    @weakify(self);
//    [model bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionNew task:^(UGSlaveRateModel *obj, NSDictionary *change) {
//        @strongify(self);
//        self.selectImag.image = [UIImage  imageNamed: obj.selected ? @"Rate_Select" : @"Rate_Unselect"];
//        self.rateLable.textColor = obj.selected ? UG_MainColor : [UIColor colorWithHexString:@"666666"];
//        self.shareBounsLabel.textColor = obj.selected ? UG_MainColor : [UIColor colorWithHexString:@"666666"];
//        self.backgroundColor = model.selected ? [UIColor colorWithHexString:@"F5F5F5"] : [UIColor whiteColor];
//    }];
}
//- (void)dealloc {
//    [self.model bk_removeAllBlockObservers];
//}

-(BOOL)useCustomStyle{
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
