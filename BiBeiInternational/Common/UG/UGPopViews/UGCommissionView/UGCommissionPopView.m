//
//  UGCommissionPopView.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGCommissionPopView.h"
#import "UGButton.h"
#import "PopView.h"
#import "UGCommissonViewCell.h"

@interface UGCommissionPopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *tureStr;
@property (nonatomic ,copy) NSArray *titles;
@property (nonatomic,strong)UGButton *cancelBtn;
@property (nonatomic,strong)UGButton *tureBtn;
@property (copy, nonatomic) void(^clickHandle)(void);
@property(nonatomic, strong)PopView *popView;
- (instancetype)initWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithTureBtn:(NSString *)tureStr clickItemHandle:(void(^)(void))clickHandle;
@end

#define titleHeight UG_AutoSize(50)
#define btnHeight UG_AutoSize(40)
#define space  UG_AutoSize(15)
#define CancelTag 6666
#define TureTag 8888
#define Identifier  @"UGCommissonViewCell"

@implementation UGCommissionPopView
+ (void)showPopViewWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithTureBtn:(NSString *)tureStr  clickItemHandle:(void(^)(void))clickHandle{
    UGCommissionPopView *centerView =[[UGCommissionPopView alloc] initWithTitle:title Titles:titles WithTureBtn:tureStr clickItemHandle:^{
        if (clickHandle) {
            clickHandle();
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

- (instancetype)initWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithTureBtn:(NSString *)tureStr clickItemHandle:(void(^)(void))clickHandle
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(UG_AutoSize(32), (kWindowH-UG_AutoSize(336))/2, kWindowW-2*UG_AutoSize(32), UG_AutoSize(336));
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
            self.layer.cornerRadius = 4;
            self.title = title;
            self.tureStr = tureStr;
            self.titles = titles;
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, titleHeight);
    [self addSubview:self.titleLabel];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGCommissonViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.cancelBtn.frame = CGRectMake(UG_AutoSize(20), self.bounds.size.height-space-btnHeight, UG_AutoSize(90), btnHeight);
    [self addSubview:self.cancelBtn];
    
    self.tureBtn.frame = CGRectMake(self.bounds.size.width-UG_AutoSize(20)-UG_AutoSize(90), self.bounds.size.height-space-btnHeight, UG_AutoSize(90), btnHeight);
    [self addSubview:self.tureBtn];
}

#pragma mark-取消、确定
-(void)btnClick:(UIButton *)sender{
    if (sender.tag == TureTag && self.clickHandle) {
        self.clickHandle();
    }
    [PopView hidenPopView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGCommissonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (UG_CheckArrayIsEmpty(self.titles) || self.titles.count<=0 || indexPath.row>=self.titles.count)
        return cell;
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"类别";
    }else if(indexPath.section == 1){
        cell.titleLabel.text = @"委托价";
    }else if(indexPath.section == 2){
        cell.titleLabel.text = @"委托量";
    }else if(indexPath.section == 3){
        cell.titleLabel.text = @"委托总额";
    }
    NSString *title =self.titles[indexPath.section];
    cell.contentLabel.text = title;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UG_AutoSize(44);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UG_AutoSize(10);
}
#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleHeight, self.bounds.size.width,self.bounds.size.height-titleHeight-2*space-btnHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
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
        _cancelBtn.layer.cornerRadius = 4;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
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
        [_tureBtn setTitle:self.tureStr forState:UIControlStateNormal];
        _tureBtn.tag = TureTag;
        _tureBtn.layer.cornerRadius = 4;
        _tureBtn.titleLabel.font = UG_AutoFont(16);
        [_tureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureBtn;
}
@end
