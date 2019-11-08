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

    CGFloat height = ceil(titles.count/2.0f) *55;
//    for (id object in titles) {
//        if ([object isKindOfClass:[UGBankInfoModel class]]) {
//            height += 12;
//        }
//    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{@weakify(self)
    UGPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGPayWayCell class]) forIndexPath:indexPath];
//    cell.model = self.titles[indexPath.section];
    
    
    [[cell.btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        self.selectedIndex = indexPath.section==0 ? 0 : 2;
        [self.tableView reloadData];
        
        void(^selectedHandle)(NSString *title, NSInteger index) = objc_getAssociatedObject(self, UGPayWayViewSelectedHandleKey);
        if (selectedHandle) {
            selectedHandle(self.titles[self.selectedIndex],self.selectedIndex);
        }
    }];
    [[cell.btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        self.selectedIndex = indexPath.section==0 ? 1 : 3;
        [self.tableView reloadData];
        
        void(^selectedHandle)(NSString *title, NSInteger index) = objc_getAssociatedObject(self, UGPayWayViewSelectedHandleKey);
        if (selectedHandle) {
            selectedHandle(self.titles[self.selectedIndex],self.selectedIndex);
        }
    }];
    
    if (indexPath.section==0) {
        if (self.titles.count>=2) {
            cell.models = @[self.titles[0],self.titles[1]];
        }else{
            cell.models = @[self.titles[0],@""];
        }
    }else if (indexPath.section==1){
        if (self.titles.count>=4) {
            cell.models = @[self.titles[2],self.titles[3]];
        }else{
            cell.models = @[self.titles[2],@""];
        }
    }
    
    [cell upCheck:indexPath.section index:self.selectedIndex];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ceil(self.titles.count/2.0f) ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.selectedIndex = indexPath.section;
//    [self.tableView reloadData];
//    void(^selectedHandle)(NSString *title, NSInteger index) = objc_getAssociatedObject(self, UGPayWayViewSelectedHandleKey);
//    if (selectedHandle) {
//        selectedHandle(self.titles[indexPath.section],indexPath.section);
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.titles[indexPath.section] isKindOfClass:[UGBankInfoModel class]]) {
//        return 56;
//    }
    return 55;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [UIView new];
//    footerView.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
//    return footerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return section == self.titles.count - 1 ? 0 : 1;
//}

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
