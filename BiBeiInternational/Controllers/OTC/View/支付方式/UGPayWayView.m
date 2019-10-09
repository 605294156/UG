//
//  OTCPayWayView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayWayView.h"
#import "UGPayWayCell.h"
#import "UGPayInfoModel.h"

static const void *UGPayWayViewSelectedHandleKey = &UGPayWayViewSelectedHandleKey;

@interface UGPayWayView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy) NSArray *titles;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSInteger selectedIndex;
@end

@implementation UGPayWayView


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles handle:(void(^) (NSString *title, NSInteger index))handle {

    CGFloat height = titles.count *44;
    for (id object in titles) {
        if ([object isKindOfClass:[UGBankInfoModel class]]) {
            height += 12;
        }
    }
    frame.size.height = height;
    self = [[UGPayWayView alloc] initWithFrame:frame];

    if (self) {
        objc_setAssociatedObject(self, UGPayWayViewSelectedHandleKey, handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.titles = titles.copy;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndex = NSNotFound;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    if (_titles.count>0 && _titles.count == 1) {
        self.selectedIndex = 0;
        void(^selectedHandle)(NSString *title, NSInteger index) = objc_getAssociatedObject(self, UGPayWayViewSelectedHandleKey);
        if (selectedHandle) {
            selectedHandle(self.titles[0],0);
        }
    }
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGPayWayCell class]) forIndexPath:indexPath];
    cell.model = self.titles[indexPath.section];
    cell.check = self.selectedIndex == indexPath.section;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.section;
    [self.tableView reloadData];
    void(^selectedHandle)(NSString *title, NSInteger index) = objc_getAssociatedObject(self, UGPayWayViewSelectedHandleKey);
    if (selectedHandle) {
        selectedHandle(self.titles[indexPath.section],indexPath.section);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titles[indexPath.section] isKindOfClass:[UGBankInfoModel class]]) {
        return 56;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.titles.count - 1 ? 0 : 1;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGPayWayCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGPayWayCell class])];
    }
    return _tableView;
}


@end
