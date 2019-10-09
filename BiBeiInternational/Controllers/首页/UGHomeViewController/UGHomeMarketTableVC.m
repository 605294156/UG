//
//  UGHomeMarketTableVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/20.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMarketTableVC.h"
#import "UGHomeMarketCell.h"
#import "marketManager.h"
#import "HomeNetManager.h"
#import "symbolModel.h"
#import "MarketNetManager.h"
#import "MarketViewController.h"
#import "KchatViewController.h"
#import "AppDelegate.h"
#import "UGSymbolThumbApi.h"
#import "UGSymbolThumbModel.h"
#import "UGFavorFindApi.h"

@interface UGHomeMarketTableVC (){
      BOOL _isDragging;
}
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UIView *btnView;
@property (nonatomic,strong)NSMutableArray *baseArray;
@property (nonatomic,strong)NSDictionary *marketDict;
@property (nonatomic,strong)NSMutableArray *currentMarketDataArr;
@property (nonatomic,strong)NSMutableArray *collectionArray;
@property (nonatomic,strong)NSMutableArray *allArray;
@end

@implementation UGHomeMarketTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowCNY) name:SHOWCNY object:nil];
}

- (NSMutableArray *)currentMarketDataArr {
    if (!_currentMarketDataArr) {
        _currentMarketDataArr = [NSMutableArray array];
    }
    return _currentMarketDataArr;
}

- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableArray *)baseArray {
    if (!_baseArray) {
        _baseArray = [NSMutableArray array];
    }
    return _baseArray;
}

- (NSMutableArray *)collectionArray {
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.baseCoin isEqualToString:@"自选"]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)setBaseCoin:(NSString *)baseCoin{
    _baseCoin = baseCoin;
    [self.tableView.mj_header beginRefreshing];
}

-(void)setupTableView{
    [self.view addSubview:self.tableView];
    if ([self.baseCoin isEqualToString:@"自选"]) {
        [self.view addSubview:self.btnView];
        [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.mas_equalTo(UG_AutoSize(80));
        }];
       
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(self.btnView.mas_top);
        }];
    }else
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
}

-(UIView *)btnView{
    if (!_btnView) {
        _btnView = [[UIView alloc] init];
        _btnView.backgroundColor = [UIColor clearColor];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(UG_AutoSize(68), UG_AutoSize(10), kWindowW-2*UG_AutoSize(68), UG_AutoSize(46))];
        [btn setTitle:@"+ 新增自选" forState:UIControlStateNormal];
        btn.titleLabel.font = UG_AutoFont(16);
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:UG_MainColor forState:UIControlStateNormal];
        btn.layer.borderColor =UG_MainColor.CGColor ;
        btn.layer.borderWidth = 1.0f;
        [btn addTarget:self action:@selector(addSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:btn];
    }
    return _btnView;
}

#pragma mark - 新增自选
-(void)addSelected:(UIButton *)sender{
    if (self.selectedClick) {
        self.selectedClick();
    }
}

#pragma mark - 切换美元、人民币
-(void)isShowCNY{
    [self.tableView reloadData];
}

-(void)initUI{
    [self languageChange];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGHomeMarketCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGHomeMarketCell class])];
}

#pragma mark -国际化通知处理事件
- (void)languageChange {

}

-(void)loadData{
    if ([self.baseCoin isEqualToString:@"自选"]) {
        if ([[UGManager shareInstance]hasLogged]) {
            [self getPersonAllCollection];//获取全部自选
        }else{
            [self showLoginViewController];
        }
    }else{
            [self getData];
    }
}

#pragma mark - 刷新数据
-(void)refreshData{
    [self loadData];
}

#pragma mark-获取所有交易币种缩略行情
-(void)getData{
    UGSymbolThumbApi *api = [UGSymbolThumbApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            [self.baseArray removeAllObjects];
            if ([object isKindOfClass:[NSDictionary class]]) {
                self.marketDict  = (NSDictionary *)object;
                self.baseArray = [NSMutableArray arrayWithArray:[self.marketDict allKeys]];
                if (self.baseArray.count>0 && self.marketDict)
                {
                    self.currentMarketDataArr = [UGSymbolThumbModel mj_objectArrayWithKeyValuesArray:[self.marketDict objectForKey:self.baseCoin]];
                }
                [self.tableView reloadData];
            }
        }
     [self isShowEmptyView];
     [self.tableView.mj_header endRefreshing];
    }];
}

-(void)isShowEmptyView{
    if (self.currentMarketDataArr.count<=0) {
        [self showTableViewEmptyView];
    }else{
        [self hiddenTableViewEmpty];
    }
}

#pragma mark -获取个人全部自选
-(void)getPersonAllCollection{
    UGFavorFindApi *api = [UGFavorFindApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if (self.collectionArray.count>0){
                [self.collectionArray removeAllObjects];
            }
            self.collectionArray = [UGSymbolThumbModel mj_objectArrayWithKeyValuesArray:object ];
            [self.tableView reloadData];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
        if (self.collectionArray.count<=0) {
            [self showTableViewEmptyView];
        }else{
            [self hiddenTableViewEmpty];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.baseCoin isEqualToString:@"自选"] && self.collectionArray.count>0) {
        return self.collectionArray.count;
    }else{
        return self.currentMarketDataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGHomeMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGHomeMarketCell class]) forIndexPath:indexPath];
    if ([self.baseCoin isEqualToString:@"自选"] ) {
        if (self.collectionArray.count>0) {
            UGSymbolThumbModel *model = self.collectionArray[indexPath.row];
            [cell configDataWithModel: model];
            if (((AppDelegate*)[UIApplication sharedApplication].delegate).isShowCNY) {
                NSString *str1 = [NSString ug_positiveFormatWithMultiplier:model.close multiplicand:model.baseUsdRate scale:6 roundingMode:NSRoundDown];
                NSString *cnyStr =[NSString ug_positiveFormatWithMultiplier:str1 multiplicand:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate scale:6 roundingMode:NSRoundDown];
                cell.cnyLabel.text=[NSString stringWithFormat:@"¥ %@",cnyStr];//计算人民币 切换美元
            }else{
                NSString *usdStr = [NSString stringWithFormat:@"%@",[NSString ug_positiveFormatWithMultiplier:model.close multiplicand:model.baseUsdRate scale:6 roundingMode:NSRoundDown]];
                cell.cnyLabel.text=[NSString stringWithFormat:@"$ %@",usdStr];
            }
        }
    }else{
        if (self.currentMarketDataArr.count>0) {
            UGSymbolThumbModel *model = self.currentMarketDataArr[indexPath.row];
            [cell configDataWithModel: model];
            if (((AppDelegate*)[UIApplication sharedApplication].delegate).isShowCNY) {
                NSString *str1 = [NSString ug_positiveFormatWithMultiplier:model.close multiplicand:model.baseUsdRate scale:6 roundingMode:NSRoundDown];
                NSString *cnyStr =[NSString ug_positiveFormatWithMultiplier:str1 multiplicand:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate scale:6 roundingMode:NSRoundDown];
                cell.cnyLabel.text=[NSString stringWithFormat:@"¥ %@",cnyStr];//计算人民币 切换美元
            }else{
                NSString *usdStr = [NSString stringWithFormat:@"%@",[NSString ug_positiveFormatWithMultiplier:model.close multiplicand:model.baseUsdRate scale:6 roundingMode:NSRoundDown]];
                cell.cnyLabel.text=[NSString stringWithFormat:@"$ %@",usdStr];
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.baseCoin isEqualToString:@"自选"] && self.collectionArray.count>0) {
        UGSymbolThumbModel *model = self.collectionArray[indexPath.row];
        if (self.cellClick) {
            self.cellClick(model);
        }
    }else{
         UGSymbolThumbModel *model = self.currentMarketDataArr[indexPath.row];
        if (self.cellClick) {
              self.cellClick(model);
        }
    }
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.baseCoin isEqualToString:@"自选"])
        return YES;
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && [self.baseCoin isEqualToString:@"自选"]) {
        //删除自选
        if (self.collectionArray>0){
            UGSymbolThumbModel *model = self.collectionArray[indexPath.row];
            [self deleteCollectionWithsymbol:model.symbol];
        }
    }
}

/*删除
 */
-(void)deleteCollectionWithsymbol:(NSString*)symbol{
    [MBProgressHUD ug_showHUDToKeyWindow];
    [MarketNetManager deleteMyCollectionWithsymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self loadData];
                [self.view ug_showToastWithToast:@"删除成功"];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}

#pragma mark - 移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
