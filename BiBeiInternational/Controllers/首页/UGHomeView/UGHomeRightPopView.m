//
//  UGHomeRightPopView.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeRightPopView.h"
#import "UGHomeRightPopViewCell.h"
#define  HomeRightPopViewCellIdentifier @"UGHomeRightPopViewCell"

@interface UGHomeRightPopView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UIViewController *controller;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation UGHomeRightPopView

-(instancetype)initWithController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor =[[UIColor colorWithRed:8/255.0 green:8/255.0 blue:8/255.0 alpha:1] colorWithAlphaComponent:0.5];
        self.controller = controller;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGHomeRightPopViewCell" bundle:nil] forCellReuseIdentifier:HomeRightPopViewCellIdentifier];
    [self.tableView reloadData];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.image = [UIImage imageNamed:@"ug_home_sideimage.png"];
        _backImageView.hidden = YES;
    }
    return _backImageView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,0,0,0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return !UG_CheckArrayIsEmpty(self.titleArray) && self.titleArray.count>0?self.titleArray.count:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UGHomeRightPopViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HomeRightPopViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (!UG_CheckArrayIsEmpty(self.titleArray) && self.titleArray.count>0) {
        cell.imagView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
        cell.titleLabel.text = self.titleArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellClick) {
        self.cellClick(self,indexPath.row);
    }
}

-(void)setTitleArray:(NSArray *)titleArray withIconArray:(NSArray *)iconArray
{
    self.titleArray = titleArray;
    self.iconArray = iconArray;
    if (!UG_CheckArrayIsEmpty(self.titleArray) && self.titleArray.count>0) {
        [self setViewsFreame];
    }
    [self.tableView reloadData];
}

-(void)cellClick:(void (^)(UGHomeRightPopView *, NSInteger))block{
    self.cellClick = block;
}

-(void)setViewsFreame{
     if (!UG_CheckArrayIsEmpty(self.titleArray) && self.titleArray.count>0) {
         self.backImageView.frame = CGRectMake(kWindowW-UG_AutoSize(14)-UG_AutoSize(112), [UG_MethodsTool navigationBarHeight], UG_AutoSize(112), self.titleArray.count>5?UG_AutoSize(165):(UG_AutoSize(8)+UG_AutoSize(5)+self.titleArray.count*35));
         self.tableView.frame =CGRectMake(UG_AutoSize(5), UG_AutoSize(8), UG_AutoSize(112)-UG_AutoSize(10), self.titleArray.count>5?(UG_AutoSize(165)-UG_AutoSize(8)-UG_AutoSize(5)):self.titleArray.count*35);
     }
}

#pragma mark- 显示视图
- (void)show{
    self.backImageView.hidden = NO;
    //设置出现的大小
    CGRect thisFrame = CGRectMake(kWindowW-UG_AutoSize(14)-UG_AutoSize(112), [UG_MethodsTool navigationBarHeight], UG_AutoSize(112),self.titleArray.count>5?UG_AutoSize(165):(UG_AutoSize(8)+UG_AutoSize(5)+self.titleArray.count*35));
    //动画显示
    [UIView animateWithDuration:0.3 animations:^{
        self.backImageView.frame = thisFrame;
    } completion:^(BOOL finished) {
    }];
    //将本身加Window上 因为要遮盖tabbar 不能加在View 上
    [[self lastWindow] addSubview:self];
//   [self.controller.view addSubview:self];
}

#pragma mark- 隐藏视图
-(void)hide
{
    //隐藏
    CGRect thisFrame =CGRectMake(kWindowW-UG_AutoSize(14)-UG_AutoSize(112), -[UG_MethodsTool navigationBarHeight], UG_AutoSize(112), -self.titleArray.count>5?UG_AutoSize(165):(UG_AutoSize(8)+UG_AutoSize(5)+self.titleArray.count*35));
    self.backImageView.frame = thisFrame;
    self.backImageView.hidden = YES;
    [self removeFromSuperview];
}

-(UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds,[UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.backImageView]) {
        return NO;
    }
    return YES;
}
@end
