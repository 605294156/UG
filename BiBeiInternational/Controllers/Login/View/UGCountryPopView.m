//
//  UGCountryPopView.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCountryPopView.h"
#import "PopView.h"

@interface UGCountryPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *backImage;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *orderArr;
@property (copy, nonatomic) void(^clickHandle)(NSString *title,NSInteger index);
@property (nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic) CGRect viewFrame;
@end

@implementation UGCountryPopView

- (instancetype)initWithFrame:( CGRect)viewFrame WithArr:(NSMutableArray *)orderArr WithIndex:(NSInteger)index WithHandle:(void (^)(NSString *title, NSInteger index))clickHandle{
    self = [super init];
    if (self) {
        CGFloat height = 265;
        self.viewFrame =viewFrame;
         CGRect viewRect = viewFrame;//按钮在视图上的位置
        CGRect  frame = CGRectMake(viewRect.origin.x, viewRect.origin.y+viewRect.size.height+2, viewRect.size.width, height);
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.backgroundColor = [UIColor clearColor];
            self.layer.cornerRadius = 4;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.layer.borderWidth = 0.5f;
            self.layer.masksToBounds = YES;
            self.clickHandle = clickHandle;
            self.orderArr =[orderArr mutableCopy];
            self.selectedIndex = index;
//            [UIView beginAnimations:nil context:nil];//动画
//            [UIView setAnimationDuration:0.3];
//            self.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y+viewRect.size.height+2, viewRect.size.width, height);
            [self initUI];
        }
    }
    return self;
}

-(void)showDropDownMenuWithBtnFrame:(CGRect)viewRect{
    CGFloat height = 265;
//    [UIView beginAnimations:nil context:nil];//动画
//    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y+viewRect.size.height+2, viewRect.size.width, height);
}

-(void)hideDropDownMenuWithBtnFrame:(CGRect)btnFrame {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y+btnFrame.size.height+2, btnFrame.size.width, 0);
//    self.tableView.frame = CGRectMake(0, 0, btnFrame.size.width, 0);
//    [UIView commitAnimations];
}

-(void)setIndex:(NSInteger)index{
    self.selectedIndex = index;
    [self.tableView reloadData];
}

-(void)initUI{
    [self addSubview:self.backImage];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
}

-(UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _backImage.userInteractionEnabled = YES;
        _backImage.image =[UIImage imageNamed:@"bg_countryimage"];
    }
    return _backImage;
}

#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(UG_AutoSize(5), UG_AutoSize(5), self.bounds.size.width-2*UG_AutoSize(5),self.bounds.size.height-2*UG_AutoSize(5)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryCell"];
    }
    NSString *title = self.orderArr[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if ([title isEqualToString:self.orderArr[self.selectedIndex]]) {
        cell.textLabel.textColor = UG_MainColor;
    }else{
         cell.textLabel.textColor = UG_BlackColor;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *title = self.orderArr[indexPath.row];
     self.clickHandle(title,indexPath.row);
     [self hideDropDownMenuWithBtnFrame:self.viewFrame];
}
@end
