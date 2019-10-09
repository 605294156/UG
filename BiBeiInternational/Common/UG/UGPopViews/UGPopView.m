//
//  UGPopView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPopView.h"
#import "PopView.h"

@interface UGPopView()<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames;


@property(nonatomic, copy) void (^clickItemHandle) (NSInteger index);

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,copy) NSArray *titles;
@property (nonatomic ,copy) NSArray *imgNames;

@end

@implementation UGPopView

+ (void)showPopViewWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames onView:(UIView *)view clickItemHandle:(void(^)(NSInteger index))clickHandle {
    UGPopView *listView = [[UGPopView alloc] initWithTitles:titles imgNames:imgNames];
    listView.backgroundColor = [UIColor whiteColor];
    listView.layer.cornerRadius = 5;
    PopView *popView = [PopView popUpContentView:listView direct:PopViewDirection_PopUpBottom onView:view];
    listView.clickItemHandle = ^(NSInteger index) {
        [PopView hidenPopView];
            if (clickHandle) {
                clickHandle(index);
            }
    };
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.didRemovedFromeSuperView = ^{
        [listView removeFromSuperview];
    };
}

- (instancetype)initWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames
{
    CGRect frame = CGRectMake(0, 0, 150, titles.count*44);
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.imgNames = imgNames;
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = UG_MainColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row != self.titles.count - 1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(7, 44 - 1, 150 - 7*2, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
        [cell.contentView addSubview:lineView];
    }
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    if (self.imgNames.count>indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:self.imgNames[indexPath.row]];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickItemHandle) {
        self.clickItemHandle(indexPath.row);
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
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


@end
