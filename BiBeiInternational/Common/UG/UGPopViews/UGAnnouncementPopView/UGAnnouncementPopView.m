//
//  UGAnnouncementPopView.m
//  BiBeiInternational
//
//  Created by keniu on 2019/5/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAnnouncementPopView.h"
#import "PopView.h"
#import "UGNewGuidStatusManager.h"

@interface  UGAnnouncementPopView()

@property(nonatomic,strong)UGAnnouncementPopView *announcementPopView;

@end

@implementation UGAnnouncementPopView

+(instancetype)shareInstance
{
    static UGAnnouncementPopView *announcementView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        announcementView = [[UGAnnouncementPopView alloc]init];
    });
    return announcementView;
}


-(void)showPopViewWithTitle:(NSString *)title WithAnnouncement:(NSString *)announcement
{
    // 上下 187 ;
    //最大高度 440。最小高度220
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGAnnouncementPopView"owner:self options:nil];
    _announcementPopView = [nibView objectAtIndex:0];
    _announcementPopView.layer.cornerRadius = 4;
    _announcementPopView.layer.masksToBounds  = YES;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };

    NSAttributedString *attributedString =[[NSAttributedString alloc] initWithString:announcement attributes:attributes];
    _announcementPopView.contentTextView.attributedText = attributedString;
    CGFloat contentHeight = [UG_MethodsTool heightWithFontSize:13 text:announcement needWidth:kWindowW -60 - 60 lineSpacing:5];
    if ((contentHeight + 187) < 220)
    {
        _announcementPopView.frame = CGRectMake(0, 0, kWindowW-60,220);
    }
    else if (((contentHeight + 187) < 440))
    {
        _announcementPopView.frame = CGRectMake(0, 0, kWindowW-60,contentHeight+187);
    }
    else
    {
        _announcementPopView.frame = CGRectMake(0, 0, kWindowW-60,440);
    }
    _announcementPopView.tittleLabel.text = title;
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
    [self.announcementPopView.contentTextView setContentOffset:CGPointZero animated:NO];
    }];
    PopView *popView =[PopView popSideContentView:_announcementPopView direct:PopViewDirection_SlideInCenter];
    popView.clickOutHidden = NO;
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.didRemovedFromeSuperView = ^{
        [self.announcementPopView removeFromSuperview];
    };
}

+(void)hidePopView{
    [PopView hidenPopView];
}

- (IBAction)buttonClick:(id)sender {
    [PopView hidenPopView];
    [UGNewGuidStatusManager shareInstance].AnnouncementIsViewByUser = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UGAnnouncementPopViewButtonClick" object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
