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
@property (nonatomic,strong)UIView *backView;
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
//        CGFloat height = UG_AutoSize(332);
        self.viewFrame =frame;
//        CGRect viewRect = frame;//按钮在视图上的位置
//        CGRect  frame = CGRectMake(viewRect.origin.x, viewRect.origin.y+viewRect.size.height+2, viewRect.size.width, height);
//        CGRect  frame = CGRectMake(viewRect.origin.x, frame.size.height-height, viewRect.size.width, height);
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//            self.layer.cornerRadius = 4;
//            self.layer.borderColor = [UIColor clearColor].CGColor;
//            self.layer.borderWidth = 0.5f;
//            self.layer.masksToBounds = YES;
            self.clickHandle = clickHandle;
            self.dataArr =[dataArr mutableCopy];
            [self initUI];
        }
    }
    return self;
}

-(void)showMenuWithFrame:(CGRect)viewRect{
    self.frame = viewRect;
}

-(void)hideMenuWithFrame:(CGRect)btnFrame {
    self.frame = CGRectMake(0, self.bounds.size.height, 0, 0);
}

-(void)initUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.lineLabel];
    [self.backView addSubview:self.tableView];
    [self.tableView reloadData];
    UIButton *sureBut = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_tableView.frame)+18, _backView.frame.size.width-50, 44)];
    [sureBut setTitle:@"确认" forState:UIControlStateNormal];
    [sureBut setTitleColor:UG_WhiteColor forState:UIControlStateNormal];
    sureBut.titleLabel.font = UG_AutoFont(16);
    [sureBut setBackgroundColor:[UIColor colorWithHexString:@"6684c7"]];
    [sureBut addTarget:self action:@selector(sureButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:sureBut];
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-332, self.bounds.size.width, 332)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _backView.frame.size.width-40, 51)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.text = @"下级费率/我的分红";
    }
    return _titleLabel;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame)
                                                               , _backView.frame.size.width-40, 0.5)];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    }
    return _lineLabel;
}

#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineLabel.frame), _backView.frame.size.width,207) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor whiteColor];
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
    return UG_AutoSize(51);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.rateModel) {
         self.rateModel.selected = NO;
    }
    UGSlaveRateModel *model = self.dataArr[indexPath.row];
    model.selected = YES;
    self.rateModel = model ;
    [self.tableView reloadData];
}

- (void)sureButAction
{
    self.clickHandle(self.rateModel);
    [self hideMenuWithFrame:self.viewFrame];
}

@end
