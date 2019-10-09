//
//  UGAddSelfSelectedVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/24.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGAddSelfSelectedVC.h"
#import "UGAddSelfSelectedCell.h"
#import "KchatViewController.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "UGSaveFavorSymbolBatchApi.h"
#import "symbolModel.h"

@interface UGAddSelfSelectedVC ()
@property(nonatomic,strong)UIView *btnView;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *selectedmodelArr;
@property(nonatomic,strong)NSMutableArray *isColletionmodelArr;
@end

@implementation UGAddSelfSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    [self languageChange];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAddSelfSelectedCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAddSelfSelectedCell class])];
    self.noDataTipText = @"暂无可自选数据";
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -国际化通知处理事件
- (void)languageChange {
    self.title = @"添加自选";
}

-(void)setupTableView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(UG_AutoSize(80));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.btnView.mas_top);
    }];
}

-(NSMutableArray *)selectedmodelArr{
    if (!_selectedmodelArr) {
        _selectedmodelArr = [[NSMutableArray alloc] init];
    }
    return _selectedmodelArr;
}

-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [[NSMutableArray alloc] init];
    }
    return _contentArr;
}

-(NSMutableArray *)isColletionmodelArr{
    if (!_isColletionmodelArr) {
        _isColletionmodelArr = [[NSMutableArray alloc] init];
    }
    return _isColletionmodelArr;
}

-(UIView *)btnView{
    if (!_btnView) {
        _btnView = [[UIView alloc] init];
        _btnView.backgroundColor = [UIColor clearColor];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(UG_AutoSize(68), UG_AutoSize(10), kWindowW-2*UG_AutoSize(68), UG_AutoSize(46))];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        btn.titleLabel.font = UG_AutoFont(16);
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:UG_MainColor forState:UIControlStateNormal];
        btn.layer.borderColor =UG_MainColor.CGColor ;
        btn.layer.borderWidth = 1.0f;
        [btn addTarget:self action:@selector(saveSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:btn];
    }
    return _btnView;
}

#pragma mark - 保存
-(void)saveSelected:(UIButton *)sender{
    if (self.selectedmodelArr.count<=0) {
        [self.view ug_showToastWithToast:@"请选择添加"];
        return;
    }
    NSMutableArray *arr = [NSMutableArray new];
    [self.selectedmodelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        symbolModel * model =(symbolModel *)obj;
        [arr addObject:model.symbol];
    }];
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGSaveFavorSymbolBatchApi *api = [UGSaveFavorSymbolBatchApi alloc];
    api.symbolList = arr;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
         if (!apiError) {
            [self.view ug_showToastWithToast:@"保存成功"];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(void)refreshData{
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    //2次请求加入
    dispatch_group_async(group, queue, ^{
        [self getData:^(BOOL complete) {
            NSLog(@"api--获取所有数据");
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        [self getPersonAllCollection:^(BOOL complete) {
            NSLog(@"api--获取自选数据");
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        //1.5个请求对应5次信号等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //2.在这里 进行请求后的方法，回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [self isCollection];
            [self.tableView.mj_header endRefreshing];
            if(self.contentArr.count<=0) {
                self.btnView.hidden = YES;
                [self showTableViewEmptyView];
            }
            else {
                self.btnView.hidden = NO;
                [self hiddenTableViewEmpty];
            }
        });
    });
}

#pragma mark- 筛选目前自选数据
-(void)isCollection{
    NSMutableArray *isNoCollection = [self.contentArr mutableCopy];
    [isNoCollection enumerateObjectsUsingBlock:^(symbolModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.isColletionmodelArr enumerateObjectsUsingBlock:^(symbolModel *obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:obj2.symbol]) {
                [self.contentArr removeObject:obj];
            }
        }];
    }];
    [self.tableView reloadData];
}

#pragma mark -获取提供选择的自选数据
-(void)getData:(void(^)(BOOL complete))completeHandle{
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                if (self.contentArr.count>0)
                    [self.contentArr removeAllObjects];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    [self.contentArr addObject:model];
                }
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
        completeHandle(YES);
    }];
   
}

#pragma mark -获取个人全部自选
-(void)getPersonAllCollection:(void(^)(BOOL complete))completeHandle{
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                if (self.isColletionmodelArr.count>0)
                    [self.isColletionmodelArr removeAllObjects];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    [self.isColletionmodelArr addObject:model];
                }
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"networkAbnormal")];
        }
        completeHandle(YES);
    }];
}

-(BOOL)isExsit:(symbolModel *)model WithArray:(NSArray *)arr{
    BOOL isexsit = false;
    if (arr.count>0) {
        for (symbolModel *item in arr) {
            if ([item.symbol isEqualToString:model.symbol]) {
                isexsit = YES;
            }
        }
    }
    return isexsit;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
   return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGAddSelfSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGAddSelfSelectedCell class]) forIndexPath:indexPath];
    symbolModel*model=self.contentArr[indexPath.row];
    cell.iconImage.selected = [self isExsit:model WithArray:self.selectedmodelArr];
    [cell configDataWithModel:model];
    cell.clickBtn = ^(id obj) {
        symbolModel*model=self.contentArr[indexPath.row];
        if (self.selectedmodelArr.count>0 && [self isExsit:model WithArray:self.selectedmodelArr]){
            [self.selectedmodelArr removeObject:model];
        }
        else {
            [self.selectedmodelArr addObject:model];
        }
        [self.tableView reloadData];
    };
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    symbolModel*model=self.contentArr[indexPath.row];
    if (self.selectedmodelArr.count>0 && [self isExsit:model WithArray:self.selectedmodelArr]) {
        [self.selectedmodelArr removeObject:model];
    }
    else {
        [self.selectedmodelArr addObject:model];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(BOOL)hasHeadRefresh{
    return YES;
}
-(BOOL)hasFooterRefresh{
    return NO;
}

@end
