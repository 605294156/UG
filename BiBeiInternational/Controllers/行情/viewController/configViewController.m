//
//  configViewController.m
//  bit123
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "configViewController.h"
#import "marketCell.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "MarketViewController.h"
@interface configViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isDragging;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)ChildViewType childViewType;
@property (nonatomic,strong)NSMutableArray *contentArr;
@end

@implementation configViewController

- (instancetype)initWithChildViewType:(ChildViewType)childViewType
{
    self = [super init];
    if (self) {
        self.childViewType = childViewType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpViews];
   
    if (self.childViewType==ChildViewType_USDT) {
        [self getData];
    }
    //收藏
    if (self.childViewType==ChildViewType_Collection) {
        if (([[UGManager shareInstance] hasLogged])) {
            [self getPersonAllCollection];//获取全部自选
        }else{
            [self showLoginViewController];
        }
    }
    
    [self languageChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowCNY) name:SHOWCNY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:SUBSCRIBE_SYMBOL object:nil];
}

//MARK:--国际化通知处理事件
- (void)languageChange {
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
}

-(void)notification:(NSNotification *)noti
{
    NSString *dataStr = [[noti userInfo] objectForKey:@"param"];
    NSDictionary*dic=[SocketUtils dictionaryWithJsonString:dataStr];
    //NSLog(@"接收 userInfo传递的消息：%@",dic);
    symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
    if (_isDragging) {
        return;
    }
    if (self.childViewType==ChildViewType_USDT) {
        [[marketManager shareInstance].USDTArray enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].USDTArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    else if (self.childViewType==ChildViewType_UG)
    {
        [[marketManager shareInstance].UGArray enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].UGArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }else{
        [[marketManager shareInstance].CollectionArray enumerateObjectsUsingBlock:^(symbolModel*   obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].CollectionArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

-(void)isShowCNY{
    [self.tableView reloadData];
}
#pragma mark-获取所有交易币种缩略行情
-(void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading") inView:self.view];

    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            [EasyShowLodingView hidenLoingInView:self.view];

            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [self removeAllArray];
                [self.contentArr removeAllObjects];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    [self.contentArr addObject:model];
                    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
                    NSString*baseSymbol=[array lastObject];
                    if ([baseSymbol isEqualToString:@"USDT"]) {
                        [[marketManager shareInstance].USDTArray addObject:model];
                    }else if ([baseSymbol isEqualToString:@"UG"])
                    {
                        [[marketManager shareInstance].UGArray addObject:model];
                    }
                }
                [marketManager shareInstance].AllCoinArray=self.contentArr;
                [self.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue] ==4000){
                
                [[UGManager shareInstance] signout:nil];
            }
            else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"networkAbnormal")];
        }
    }];
}
//获取个人全部自选
-(void)getPersonAllCollection{
    
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [self removeAllArray];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    NSDictionary*dict=symbolArray[i];
                    [[marketManager shareInstance].AllCoinArray enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.symbol isEqualToString:dict[@"symbol"]]) {
                            [[marketManager shareInstance].CollectionArray addObject:obj];
                        }
                    }];
                }
                [self.tableView reloadData];
                
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"networkAbnormal")];
        }
    } ];
}
- (void)refreshHeaderAction{
    [self getData];
}


- (void)setUpViews
{
    [self.view addSubview:self.tableView];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.childViewType==ChildViewType_USDT) {
        return [marketManager shareInstance].USDTArray.count;
    }else if (self.childViewType==ChildViewType_UG)
    {
       return [marketManager shareInstance].UGArray.count;
    }else{
        return [marketManager shareInstance].CollectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   marketCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell" forIndexPath:indexPath];
   cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.childViewType==ChildViewType_USDT) {
        symbolModel*model=[marketManager shareInstance].USDTArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex:(int)indexPath.row];
    }else if (self.childViewType==ChildViewType_UG)
    {
        symbolModel*model=[marketManager shareInstance].UGArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex:(int)indexPath.row];
    }else{
        symbolModel*model=[marketManager shareInstance].CollectionArray[indexPath.row];
        [cell configDataWithModel:model withtype:1 withIndex:(int)indexPath.row];
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    symbolModel*model;
    if (self.childViewType==ChildViewType_USDT) {
        model=[marketManager shareInstance].USDTArray[indexPath.row];
    }
    else if (self.childViewType==ChildViewType_UG)
    {
        model=[marketManager shareInstance].UGArray[indexPath.row];
        
    }
    else{
       model=[marketManager shareInstance].CollectionArray[indexPath.row];
    }
    MarketViewController*controller=(MarketViewController*)self.parentViewController;
    KchatViewController*klineVC=[[KchatViewController alloc]init];
    klineVC.symbol=model.symbol;
    [controller.navigationController pushViewController:klineVC animated:YES];
}
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"marketCell" bundle:nil] forCellReuseIdentifier:@"marketCell"];
        _tableView.frame=CGRectMake(0, 0, kWindowW, kWindowH-SafeAreaTopHeight-SafeAreaBottomHeight-40);
        _tableView.rowHeight=60;
        _tableView.separatorColor=[UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView=[UIView new];
    }
    return _tableView;
}
//更新数据
-(void)reloadData{
    
    if (self.childViewType==ChildViewType_USDT) {
        [self getData];
        
    }else if (self.childViewType==ChildViewType_UG)
    {
        [self getData];
    }
    else{
//        if (!([[UGManager shareInstance] hasLogged])) {
//            [self showLoginViewController];
//            return ;
//        }
        if (([[UGManager shareInstance] hasLogged])) {
            [self getPersonAllCollection];
        } 
    }
}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
-(void)removeAllArray{
    [[marketManager shareInstance].USDTArray removeAllObjects];
    [[marketManager shareInstance].UGArray removeAllObjects];
    [[marketManager shareInstance].CollectionArray removeAllObjects];
}

kRemoveCellSeparator
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
