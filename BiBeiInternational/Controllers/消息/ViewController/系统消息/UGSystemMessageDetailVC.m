//
//  UGSystemMessageDetailVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSystemMessageDetailVC.h"

@interface UGSystemMessageDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//底部间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation UGSystemMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =! self.isProclamation ? @"消息详情" : @"公告详情";
    self.contentTextView.layoutManager.allowsNonContiguousLayout = NO;//解决TextView 赋值内容后重置混动到x最后一行 
    self.bottomConstraint.constant += UG_SafeAreaBottomHeight;
    [self updateViews];
    
}

//-(void)viewDidAppear:(BOOL)animated{
//   [self.contentTextView setContentOffset:CGPointZero animated:NO];
//}

- (void)updateViews {
    self.timeLabel.text = [UG_MethodsTool getFriendyWithStartTime: !self.isProclamation ? self.notifyModel.createTime : self.createTime];
    self.titleLabel.text = !self.isProclamation ? (!UG_CheckStrIsEmpty(self.notifyModel.title) ? self.notifyModel.title : @"") : self.titleStr;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple = 20.f;
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    paragraphStyle.firstLineHeadIndent = 20.f; // 首行缩进
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor blackColor]
                                 };
    self.contentTextView.attributedText = [[NSAttributedString alloc]initWithString:!self.isProclamation ?     (self.notifyModel.content ? : @"") : self.content attributes:attributes];
}


@end
