//
//  UGSeletedBankVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSeletedBankVC.h"
#import "UGCheckBankModel.h"
#import "UGCheckBankApi.h"
#import "UGIndexView.h"
#import "UGBankSekectedCell.h"
#import "UGSetionHeaderView.h"
#import "NSArray+PinYin.h"
#import "UGSelectedBankHeader.h"

static NSString *TableViewHeaderViewIdentifier = @"UGTableViewHeaderViewIdentifier";
static NSString *TableViewCellIdentifier = @"UGTableViewCellIdentifier";
static NSString *TableViewHeaderViewIdentifier2= @"TableViewHeaderViewIdentifier2";

@interface UGSeletedBankVC ()<UGIndexViewDelegate, UGIndexViewDataSource>

@property (nonatomic, strong) UGIndexView *indexView;

@property (nonatomic, copy) NSArray *dataSourceArray;                           /**< 数据源数组 */
@property (nonatomic, strong) NSMutableArray *brandArray;                       /**< 银行名数组 */
@property (nonatomic, assign) BOOL isSearchMode;                                /**< 是否有搜索栏  */

@end

@implementation UGSeletedBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择银行卡";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGBankSekectedCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellIdentifier];
   
    [self.tableView  registerClass:[UGSetionHeaderView class] forHeaderFooterViewReuseIdentifier:TableViewHeaderViewIdentifier];
    
    [self.tableView  registerClass:[UGSelectedBankHeader class] forHeaderFooterViewReuseIdentifier:TableViewHeaderViewIdentifier2];
    
    [self.view addSubview:self.indexView];
    
    [self.indexView setSelectionIndex:0];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)refreshData{
    UGCheckBankApi *api = [UGCheckBankApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [self.tableView.mj_header endRefreshing];
        if (object) {
            self.dataSourceArray = [UGCheckBankModel mj_objectArrayWithKeyValuesArray:object];
            if(!UG_CheckArrayIsEmpty(self.dataSourceArray) &&  self.dataSourceArray.count>0){
               [self analysisData];
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark - 解析数据
-(void)analysisData{
    NSMutableArray *tempBrandArray = [NSMutableArray array];
    for (UGCheckBankModel *brandName in self.dataSourceArray) {
        NSString *name = brandName.bankNameCn;
        name = [brandName.sort isEqualToString:@"1"] ? [NSString stringWithFormat:@"1/%@",name] : name;
        [tempBrandArray addObject:name];
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
        return 44;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.isSearchMode) {
        UGSelectedBankHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderViewIdentifier2];
        @weakify(self);
        headerView.sectionBlock = ^{
            @strongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"选择银行名称" object:nil userInfo:@{@"bandName":@""}];
            [self.navigationController popViewControllerAnimated:YES];
        };
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
    NSArray *nameArray = [brandInfo componentsSeparatedByString:@"/"];
    if (nameArray.count>1) {
        brandInfo = nameArray[1];
    }
    if (array.count ==1 || indexPath.row == array.count-1) {
        cell.lineLabel.hidden = YES;
    }else{
        cell.lineLabel.hidden = NO;
    }
    cell.backNameLabel.text = brandInfo;
    return cell;
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.brandArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    NSString *brandInfo = array[indexPath.row];
    NSArray *nameArray = [brandInfo componentsSeparatedByString:@"/"];
    if (nameArray.count>1) {
        brandInfo = nameArray[1];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"选择银行名称" object:nil userInfo:@{@"bandName":brandInfo}];
    [self.navigationController popViewControllerAnimated:YES];
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
