//
//  PriceChooseView.m
//  PopView
//
//  Created by 李林 on 2018/3/9.
//  Copyright © 2018年 李林. All rights reserved.
//

#import "TRComplexChooseView.h"
#import "PopView.h"


@interface TRComplexChooseView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,copy) NSArray *titles;

@property (nonatomic ,assign) NSInteger selectedIndex;


@end

@implementation TRComplexChooseView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles selectedIndex:(NSInteger)selectedIndex {
    self = [[TRComplexChooseView alloc] initWithFrame:frame];
    if (self) {
        self.selectedIndex = selectedIndex;
        self.titles = [[NSArray alloc] initWithArray:titles];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
        [self addSubview:line];
        [self addSubview:self.tableView];
        [self setupRoundedRec];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.tableView reloadData];
}

- (void)setupRoundedRec {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, cell.contentView.bounds.size.width, 34)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = [self.titles objectAtIndex:indexPath.row];
    titleLabel.textColor = self.selectedIndex == indexPath.row ? HEXCOLOR(0x4264b8) : [UIColor colorWithHexString:@"36404e"];
    [cell.contentView addSubview:titleLabel];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_selected_icon"]];
    cell.accessoryView = self.selectedIndex==indexPath.row ? accessoryView : nil;
    if (indexPath.row == self.titles.count -1) {
        cell.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, 14, 0, 14);
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    if (self.clickHanlder) {
        self.clickHanlder(self.titles[self.selectedIndex], self.selectedIndex);
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 34;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
            
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 14)];
        }

    }
    return _tableView;
}


@end
