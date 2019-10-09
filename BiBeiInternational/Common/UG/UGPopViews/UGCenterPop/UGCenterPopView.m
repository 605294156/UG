//
//  UGCenterPopView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/20.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGCenterPopView.h"
#import "PopView.h"
#import "UGButton.h"
#import "UGCenterPopViewCell.h"
#import "PopAnimationTool.h"

@interface UGCenterPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,copy) NSArray *titles;
@property (nonatomic,copy)NSString *title;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic,strong)UGButton *cancelBtn;
@property (nonatomic,strong)UGButton *tureBtn;
@property (copy, nonatomic) void(^clickHandle)(NSString *selectedStr);
@property(nonatomic, strong)PopView *popView;
@property(nonatomic,copy)NSString *selectedStr;
- (instancetype)initWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithSelected:(NSString *)selectedStr clickItemHandle:(void(^)(NSString *obj))clickHandle;
@end

#define titleHeight UG_AutoSize(54)
#define btnHeight UG_AutoSize(40)
#define space  UG_AutoSize(15)
#define CancelTag 11111
#define TureTag 22222
#define Identifier  @"UGCenterPopViewCell"

@implementation UGCenterPopView

+ (void)showPopViewWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithSelected:(NSString *)selectedStr clickItemHandle:(void(^)(NSString *obj))clickHandle{
    
    UGCenterPopView *centerView =[[UGCenterPopView alloc] initWithTitle:title Titles:titles WithSelected:selectedStr clickItemHandle:^(NSString * _Nonnull obj) {
        if (clickHandle) {
            clickHandle(obj);
        }
    }];
    PopView *popView =[PopView popSideContentView:centerView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.didRemovedFromeSuperView = ^{
        [centerView removeFromSuperview];
    };
}

+(void)hidePopView{
    [PopView hidenPopView];
}

- (instancetype)initWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithSelected:(NSString *)selectedStr clickItemHandle:(void(^)(NSString *obj))clickHandle
{
    self = [super init];
    if (self) {
        CGFloat height =titleHeight+ ((!UG_CheckArrayIsEmpty(titles)&&titles.count>0)? titles.count*44 : 0)+2*space+btnHeight;
        if (height>UG_AutoSize(320)) {
            height =UG_AutoSize(320);
        }
        CGRect frame = CGRectMake(UG_AutoSize(48), (kWindowH-height)/2, kWindowW-2*UG_AutoSize(48), height);
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 4;
            self.selectedStr = selectedStr;
            self.title = title;
            self.titles = titles;
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, titleHeight);
    [self addSubview:self.titleLabel];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGCenterPopViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.cancelBtn.frame = CGRectMake(20, self.bounds.size.height-space-btnHeight, UG_AutoSize(80), btnHeight);
    [self addSubview:self.cancelBtn];
    
    self.tureBtn.frame = CGRectMake(self.bounds.size.width-20-UG_AutoSize(80), self.bounds.size.height-space-btnHeight, UG_AutoSize(80), btnHeight);
    [self addSubview:self.tureBtn];
}

#pragma mark-取消、确定
-(void)btnClick:(UIButton *)sender{
    if (sender.tag == TureTag && self.clickHandle) {
        self.clickHandle(self.selectedStr);
    }else
    {
        [PopView hidenPopView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGCenterPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (!UG_CheckArrayIsEmpty(self.titles) && self.titles.count>0) {
        cell.name.text = [self.titles objectAtIndex:indexPath.row];
        if (!UG_CheckStrIsEmpty(self.selectedStr) && [self.selectedStr isEqualToString:[self.titles objectAtIndex:indexPath.row]]) {
            cell.selecteBtn.selected = YES;
        }else {
            cell.selecteBtn.selected = NO;
        }
        @weakify(self);
        cell.cellClick = ^(UGCenterPopViewCell *viewCell) {
            @strongify(self);
            self.selectedStr =[self.titles objectAtIndex:indexPath.row];
            [self.tableView reloadData];
        };
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedStr =[self.titles objectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.titles.count == section) {
        return 0.5f;
    }
    return CGFLOAT_MIN;
}


#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(14, titleHeight, self.bounds.size.width-2*14,self.bounds.size.height-titleHeight-2*space-btnHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

#pragma mark - 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, UG_AutoSize(54))];
        _titleLabel.text =self.title;
        _titleLabel.font = UG_AutoFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark -取消按钮
-(UGButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UGButton alloc]initWithUGStyle:UGButtonStyleWhite];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 4;
        _cancelBtn.tag = CancelTag;
        _cancelBtn.titleLabel.font = UG_AutoFont(16);
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

#pragma mark- 确认按钮
-(UGButton *)tureBtn{
    if (!_tureBtn) {
        _tureBtn = [[UGButton alloc]initWithUGStyle:UGButtonStyleBlue];
        [_tureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _tureBtn.layer.cornerRadius = 4;
        _tureBtn.tag = TureTag;
        _tureBtn.titleLabel.font = UG_AutoFont(16);
        [_tureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureBtn;
}

@end
