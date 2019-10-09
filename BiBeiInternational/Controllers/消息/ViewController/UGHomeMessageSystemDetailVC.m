//
//  UGHomeMessageSystemDetailVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/23.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMessageSystemDetailVC.h"

@interface UGHomeMessageSystemDetailVC ()
@property(nonatomic,assign)float *maxHeights;

@end

@implementation UGHomeMessageSystemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];
}

-(void)languageChange{
    self.title = @"消息详情";
}

-(void)setTextStr:(NSString *)textStr{
    _textStr = textStr;
    [self setHeight];
}

-(void)setHeight{
//    static CGFloat maxHeight =self.frea;
    self.textVew.text = self.textStr;
    CGSize constraint = CGSizeMake(self.textVew.contentSize.width , CGFLOAT_MAX);
    CGRect size = [ self.textStr boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                        context:nil];
    float textHeight = size.size.height + 46.0;
    if (textHeight<self.backView.frame.size.height) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).mas_offset(10);
            make.right.left.equalTo(self.view).offset(14);
            make.height.mas_equalTo(textHeight);
        }];
         self.textVew.scrollEnabled = NO;
    }else
    {
        self.textVew.scrollEnabled = YES;
    }
}

@end
