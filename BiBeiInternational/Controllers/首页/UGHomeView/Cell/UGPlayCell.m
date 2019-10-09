//
//  UGPlayCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGPlayCell.h"
#import "UGPlayCellBanner/UGPlayerCellBanner.h"

@implementation UGPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}

-(void)refreshUGPlayCellWithArray:(NSArray *)itemsArray
{
    UGPlayerCellBanner  *bannerView = [[UGPlayerCellBanner alloc]initWithFrame:CGRectMake(0, 0,kWindowW,100) viewSize:CGSizeMake(kWindowW,100)];
    
    bannerView.items = itemsArray;
    
    @weakify(self);
    
    bannerView.cellClick = ^(UGPlayerCellBanner *barnerview, bannerCellModel *model) {
        
     @strongify(self);
        
        if (self.backToHomeVCBlock) {
            
            self.backToHomeVCBlock(model);
            
        }
        
    };
    
    [self.contentView addSubview:bannerView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    

    
    [super layoutSubviews];
}

-(BOOL)useCustomStyle{
    return NO;
}

@end
