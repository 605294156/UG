//
//  UGLinkmanVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/28.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGLinkmanVC.h"
#import "UGIndexView.h"
#import "UGBankSekectedCell.h"
#import "UGSetionHeaderView.h"
#import "NSArray+PinYin.h"
#import "UGSelectedBankHeader.h"
#import "UGFindLinkManVC.h"
#import "UGLinkManDetailVC.h"
#import "UGLinkModel.h"
#import "UGLinkmanApi.h"

static NSString *TableViewHeaderViewIdentifier = @"UGTableViewHeaderViewIdentifier";
static NSString *TableViewCellIdentifier = @"UGTableViewCellIdentifier";
static NSString *TableViewHeaderViewIdentifier2= @"TableViewHeaderViewIdentifier2";

@interface UGLinkmanVC ()<UGIndexViewDelegate, UGIndexViewDataSource>

@property (nonatomic, strong) UGIndexView *indexView;

@property (nonatomic, copy) NSArray *dataSourceArray;                           /**< 数据源数组 */
@property (nonatomic, strong) NSMutableArray *brandArray;                       /**< 品牌名数组 */
@property (nonatomic, assign) BOOL isSearchMode;                                /**< 是否有搜索栏  */

@end

@implementation UGLinkmanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    
//    self.noDataTipText = @"您暂时还没有联系人哦！";
//    self.noNetworkTipImage = @"link_default";
    
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"linkman_search" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item){
        @strongify(self);
        [self.navigationController pushViewController:[UGFindLinkManVC new] animated:YES];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGBankSekectedCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellIdentifier];
    
    [self.tableView  registerClass:[UGSetionHeaderView class] forHeaderFooterViewReuseIdentifier:TableViewHeaderViewIdentifier];
    
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(14, 0, UG_SCREEN_WIDTH-30, 25)];
    
    [self.tableView  registerClass:[view class] forHeaderFooterViewReuseIdentifier:TableViewHeaderViewIdentifier2];
    
    [self.view addSubview:self.indexView];
    
    [self.indexView setSelectionIndex:0];
    
    [self.tableView.mj_header beginRefreshing];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"添加联系人成功" object:nil];
}

-(void)refreshData{
    UGLinkmanApi *api = [UGLinkmanApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [self.tableView.mj_header endRefreshing];
        if (object) {
            self.dataSourceArray = [UGLinkModel mj_objectArrayWithKeyValuesArray:object];
            if(!UG_CheckArrayIsEmpty(self.dataSourceArray) &&  self.dataSourceArray.count>0){
                self.tableView.ly_emptyView.hidden = YES;
                [self analysisData];
            }else{
                LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"link_default" titleStr:LocalizationKey(@"您暂时还没有联系人哦！") detailStr:nil];
                self.tableView.ly_emptyView = emptyView;
                self.tableView.ly_emptyView.hidden = NO;
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark - 解析数据
-(void)analysisData{
    NSMutableArray *tempBrandArray = [NSMutableArray array];
    for (UGLinkModel *brandName in self.dataSourceArray) {
        [tempBrandArray addObject:brandName.username];
    }
    //获取拼音首字母
    NSArray *indexArray= [tempBrandArray arrayWithPinYinFirstLetterFormat];
    self.brandArray = [NSMutableArray arrayWithArray:indexArray];
    
    //添加搜索视图
    self.isSearchMode = YES;
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    [searchDic setObject:[NSMutableArray array] forKey:@"content"];
    [self.brandArray insertObject:searchDic atIndex:0];
    
    [self.tableView reloadData];
    [self.indexView setSelectionIndex:0];
    [self.indexView reload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.brandArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.brandArray[section];
    NSMutableArray *array = dict[@"content"];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.isSearchMode) {
        return 25;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.isSearchMode) {
        UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderViewIdentifier2];
        return headerView;
    }
    UGSetionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderViewIdentifier];
    headerView.letter = self.brandArray[section][@"firstLetter"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGBankSekectedCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.brandArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    
    NSString *brandInfo = array[indexPath.row];
    if (array.count ==1 || indexPath.row == array.count-1) {
        cell.lineLabel.hidden = YES;
    }else{
        cell.lineLabel.hidden = NO;
    }
    cell.backNameLabel.text = brandInfo;
    UGLinkModel *model = [self getDataId:array[indexPath.row]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.brandArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    UGLinkModel *model = [self getDataId:array[indexPath.row]];
    if (model) {
        UGLinkManDetailVC *vc = [UGLinkManDetailVC new];
        vc.memberId = model.memberId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UGLinkModel *)getDataId:(NSString *)name{
    UGLinkModel *models = nil;
    for (UGLinkModel *model in self.dataSourceArray) {
        if ([model.username isEqualToString:name]) {
            models = model;
            break;
        }
    }
    return models;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView willDisplayHeaderView:view forSection:section];
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.indexView scrollViewDidScroll:scrollView];
}

#pragma mark - IndexView
- (NSArray<NSString *> *)ug_sectionIndexTitles {
    //符号  [NSMutableArray arrayWithObject:UITableViewIndexSearch]; [NSMutableArray array];
    NSMutableArray *resultArray = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in self.brandArray) {
        NSString *title = dict[@"firstLetter"];
        if (title) {
            [resultArray addObject:title];
        }
    }
    return resultArray;
}

-(void)ug_selectedSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.isSearchMode && (index == 0)) {
        //搜索视图头视图(这里不能使用scrollToRowAtIndexPath，因为搜索组没有cell)
        [self.tableView setContentOffset:CGPointZero animated:NO];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//将指示器视图添加到当前视图上
- (void)ug_addIndicatorView:(UIView *)view{
    [self.view addSubview:view];
}

-(NSArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSArray new];
    }
    return _dataSourceArray;
}

-(NSMutableArray *)brandArray{
    if (!_brandArray) {
        _brandArray = [NSMutableArray new];
    }
    return _brandArray;
}

- (UGIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[UGIndexView alloc] initWithFrame:CGRectMake(UG_SCREEN_WIDTH - 30, 0, 30, UG_SCREEN_HEIGHT)];
        _indexView.delegate = self;
        _indexView.dataSource = self;
    }
    return _indexView;
}

-(BOOL)hasFooterRefresh{
    return NO;
}
@end
