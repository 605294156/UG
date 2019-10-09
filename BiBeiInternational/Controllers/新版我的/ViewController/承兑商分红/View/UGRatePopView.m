//
//  UGRatePopView.m
//  BiBeiInternational
//
//  Created by conew on 2019/8/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGRatePopView.h"
#import "UGRatePopViewCell.h"
#import "UGRateModel.h"

#define Identifier  @"UGRatePopViewCellIdentifier"
@interface UGRatePopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *backImage;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataArr;
@property (copy, nonatomic) void(^clickHandle)(UGSlaveRateModel *model);
@property(nonatomic) CGRect viewFrame;
@property(nonatomic,strong)UGSlaveRateModel *rateModel;
@end

@implementation UGRatePopView
- (instancetype)initWithViewFrame:( CGRect)frame WithDataArr:(NSArray *)dataArr WithHandle:(void (^)(UGSlaveRateModel *model))clickHandle{
    self = [super init];
    if (self) {
        CGFloat height = UG_AutoSize(240);
        self.viewFrame =frame;
        CGRect viewRect = frame;//按钮在视图上的位置
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
            self.dataArr =[dataArr mutableCopy];
            [self initUI];
        }
    }
    return self;
}

-(void)showMenuWithFrame:(CGRect)viewRect{
    CGFloat height = UG_AutoSize(240);
    self.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y+viewRect.size.height+2, viewRect.size.width, height);
}

-(void)hideMenuWithFrame:(CGRect)btnFrame {
    self.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y+btnFrame.size.height+2, btnFrame.size.width, 0);
}

-(void)initUI{
    [self addSubview:self.backImage];
    [self addSubview:self.titleLabel];
     [self addSubview:self.lineLabel];
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

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(18), 0, self.bounds.size.width-2*UG_AutoSize(18), UG_AutoSize(44))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.text = @"下级费率     /     我的分红";
    }
    return _titleLabel;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(18), UG_AutoSize(43), self.bounds.size.width-2*UG_AutoSize(18), UG_AutoSize(1))];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    return _lineLabel;
}

#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(UG_AutoSize(5), UG_AutoSize(44), self.bounds.size.width-2*UG_AutoSize(5),self.bounds.size.height-UG_AutoSize(5)-UG_AutoSize(44)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGRatePopViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGRatePopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    UGSlaveRateModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UG_AutoSize(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.rateModel) {
         self.rateModel.selected = NO;
    }
    UGSlaveRateModel *model = self.dataArr[indexPath.row];
    model.selected = YES;
    self.rateModel = model ;
    self.clickHandle(model);
    [self.tableView reloadData];
    [self hideMenuWithFrame:self.viewFrame];
}

@end
