//
//  UGAnnouncementNewPopView.m
//  BiBeiInternational
//
//  Created by keniu on 2019/8/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAnnouncementNewPopView.h"
#import "PopView.h"
#import "UGAnnouncementPopViewCell.h"
#import "UGNewGuidStatusManager.h"

@interface UGAnnouncementNewPopView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *announcement;
@property (nonatomic ,strong) UITableView *tableView;
@property (copy, nonatomic) void(^clickHandle)(void);
-(instancetype)initWithTitle:(NSString *)title andAnnouncement:(NSString *)announcement clickItemHandle:(void(^)(void))clickHandle;

@end

@implementation UGAnnouncementNewPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showPopViewWithTitle:(NSString *)title andAnnouncement:(NSString *)announcement clickItemHandle:(void(^)(void))clickHandle
{
    UGAnnouncementNewPopView *announcementNewPopView = [[UGAnnouncementNewPopView alloc]initWithTitle:title andAnnouncement:announcement clickItemHandle:^{
        if (clickHandle) {
            clickHandle();
        }
    }];
    PopView *popView =[PopView popSideContentView:announcementNewPopView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.clickOutHidden = NO;
    popView.didRemovedFromeSuperView = ^{
        [announcementNewPopView removeFromSuperview];
    };
}

-(instancetype)initWithTitle:(NSString *)title andAnnouncement:(NSString *)announcement clickItemHandle:(void(^)(void))clickHandle
{
    self = [super init];
    if (self) {
        CGFloat contentHeight = [UG_MethodsTool heightWithFontSize:13 text:announcement needWidth:kWindowW -60 - 60 lineSpacing:5];
        //公告内容之外的UI高度
        CGFloat otherHeight = 193;
        //真实高度
        CGFloat realHeight = 440;
        if ((contentHeight+otherHeight) <  220)
        {
            realHeight = 220;
        }
        else if ((contentHeight+otherHeight) <440)
        {
            realHeight = UG_AutoSize(contentHeight+otherHeight);
        }
        else
        {
            realHeight = 440;
        }
       CGRect frame = CGRectMake(UG_AutoSize(30), (kWindowH-UG_AutoSize(realHeight))/2,UG_AutoSize(kWindowW-60) ,UG_AutoSize(realHeight));
       self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 12;
            self.layer.masksToBounds = YES;
            self.title = title;
            self.announcement = announcement;
            [self initUI];
        }
    }
    return self;
    
}

-(void)initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"UGAnnouncementPopViewCell" bundle:nil] forCellReuseIdentifier:@"UGAnnouncementPopViewCell"];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    self.tableView.layer.cornerRadius = 12;
    self.tableView.layer.masksToBounds = YES;
    
}
#pragma mark - UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UGAnnouncementPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGAnnouncementPopViewCell" forIndexPath:indexPath];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSAttributedString *attributedString =[[NSAttributedString alloc] initWithString:_announcement attributes:attributes];
    cell.announcementContentTextView.attributedText = attributedString;
    cell.announcementTittleLabel.text = self.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        [cell.announcementContentTextView setContentOffset:CGPointZero animated:NO];
    }];
    [cell.iKnowButton addTarget:self action:@selector(iKnowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

#pragma mark -弹窗我知道了点击事件
-(void)iKnowButtonClick
{
    [PopView hidenPopView];
    if (self.clickHandle) {
        [UGNewGuidStatusManager shareInstance].AnnouncementIsViewByUser = YES;
        self.clickHandle();
    }
}

+(void)hidePopView{
    [PopView hidenPopView];
}
@end
