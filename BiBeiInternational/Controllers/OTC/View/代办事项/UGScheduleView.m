//
//  UGScheduleView.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGScheduleView.h"
#import "PopView.h"
#import "UGSchduleViewCell.h"

@interface UGScheduleView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic ,strong) NSMutableArray *orderArr;
@property (copy, nonatomic) void(^clickHandle)(UGOrderWaitingModel *model);
@property (copy, nonatomic) void(^scheduleView)(UGScheduleView *scheduleView);
@property (copy, nonatomic) void(^closeHandle)(void);

- (instancetype)initWithArr:(NSMutableArray *)orderArr WithHandle:(void(^)(UGOrderWaitingModel *model))clickHandle WithViewHandle:(void(^)(UGScheduleView *scheduleView))scheduleView WithCloseHandle:(void(^)( void))closeHandle;
@end

@implementation UGScheduleView
+ (void)initWithArr:(NSMutableArray *)orderArr WithHandle:(void(^)(UGOrderWaitingModel *model))clickHandle WithViewHandle:(void(^)(UGScheduleView *scheduleView))scheduleViewHandle WithCloseHandle:(void(^)( void))closeHandle{
    UGScheduleView *centerView =[[UGScheduleView alloc] initWithArr:orderArr WithHandle:^(UGOrderWaitingModel *model) {
        if (clickHandle) {
            clickHandle(model);
        }
    } WithViewHandle:^(UGScheduleView *scheduleView) {
        if (scheduleViewHandle) {
            scheduleViewHandle(scheduleView);
        }
    
    } WithCloseHandle:^{
        if (closeHandle) {
            closeHandle();
        }
     
    }];
    PopView *popView =[PopView popSideContentView:centerView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.clickOutHidden = NO;
}

+(void)hidePopView{
    [PopView hidenPopView];
}

- (instancetype)initWithArr:(NSMutableArray *)orderArr WithHandle:(void(^)(UGOrderWaitingModel *model))clickHandle WithViewHandle:(void(^)(UGScheduleView *scheduleView))scheduleView WithCloseHandle:(void(^)( void))closeHandle
{
    self = [super init];
    if (self) {
        CGFloat height =2*UG_AutoSize(15)+UG_AutoSize(150) + orderArr.count*110;
        if (height>kWindowH-2*UG_AutoSize(80)) {
            height =kWindowH-2*UG_AutoSize(80);
        }
        CGRect frame = CGRectMake(UG_AutoSize(30), (kWindowH-height)/2.0, kWindowW-2*UG_AutoSize(30), height);
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.scheduleView = scheduleView;
            self.closeHandle = closeHandle;
            self.backgroundColor = [UIColor clearColor];
            self.layer.cornerRadius = 4;
            self.orderArr =[orderArr mutableCopy];
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.imageView];
    
    [self addSubview:self.cancelBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGSchduleViewCell" bundle:nil] forCellReuseIdentifier:@"UGSchduleViewCell"];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    
    if (self.scheduleView) {
        self.scheduleView(self);
    }
}

#pragma mark - imageView
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-UG_AutoSize(250))/2.0, UG_AutoSize(15), UG_AutoSize(250), UG_AutoSize(150))];
        _imageView.image = [UIImage imageNamed:@"backlog_image"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

#pragma mark -取消按钮
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-UG_AutoSize(50), 10, UG_AutoSize(40), UG_AutoSize(40))];
        _cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [_cancelBtn setImage:[UIImage imageNamed:@"guanbi_close"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(void)btnClick:(UIButton *)sender{
    @weakify(self);
    [[UGManager shareInstance] getOrderWaitingDealList:^(BOOL complete, NSMutableArray * _Nonnull object) {
        @strongify(self);
        self.orderArr = [object mutableCopy];
        if (self.orderArr.count<=0) {
             [PopView hidenPopView];
            return;
        }
        [self.tableView reloadData];
        int num = [self forceNum];
        if (num > 0) {
            [self ug_showToastWithToast:[NSString stringWithFormat:@"您有%d个订单未付款，请您先完成付款 ！",num]];
            return;
        }
        if (self.closeHandle) {
            self.closeHandle();
        }
        [PopView hidenPopView];
    }];
}

#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UG_AutoSize(165), self.bounds.size.width,self.bounds.size.height-UG_AutoSize(165)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 6;
        _tableView.layer.masksToBounds = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGSchduleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGSchduleViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UGOrderWaitingModel *model = self.orderArr[indexPath.row];
    cell.model = model;
    cell.payClick = ^{
        [PopView hidenPopView];
        self.clickHandle(model);
    };
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UGOrderWaitingModel *model = self.orderArr[indexPath.row];
    [PopView hidenPopView];
    self.clickHandle(model);
}

-(int)forceNum{
    int num = 0;
    for (UGOrderWaitingModel *model in self.orderArr) {
        if ([model.force isEqualToString:@"1"]) {
            num ++ ;
        }
    }
    return num;
}

@end
