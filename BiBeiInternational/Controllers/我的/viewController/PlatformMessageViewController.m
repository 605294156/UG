//
//  PlatformMessageViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PlatformMessageViewController.h"
#import "PlatformMessageCell.h"                            
#import "MineNetManager.h"
#import "PlatformMessageModel.h"
#import "PlatformMessageDetailViewController.h"

@interface PlatformMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,copy)NSMutableArray *platformMessageArr;
@end

@implementation PlatformMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"平台消息";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlatformMessageCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PlatformMessageCell class])];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    [self setupRefesh];
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noDada") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
    self.pageNo = 1;
    [self getData];
}

#pragma mark - 设置刷新头尾
- (void)setupRefesh {
    @weakify(self);
    [self.tableView setupHeaderRefesh:^{
        @strongify(self);
        [self refreshHeaderAction];
    }];
    
    [self.tableView setupNomalFooterRefesh:^{
        @strongify(self);
        [self refreshFooterAction];
    }];
}

//MARK:--上拉加载
- (void)refreshFooterAction{
    [self getData];
}

//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1;
    [self getData];
}

//MARK:--获取消息
-(void)getData{
   [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
     NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    @weakify(self);
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:pageNoStr withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        @strongify(self);
        [EasyShowLodingView hidenLoding];
        NSLog(@"___%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                if (self.pageNo == 1) {
                    [self.platformMessageArr removeAllObjects];
                }
                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                //结束刷新状态
                [self.tableView endRefreshingWithNoMoreData: self.pageNo == 0 ? NO : ( dataArr.count >0 ?  : NO)];
                [self.platformMessageArr addObjectsFromArray:dataArr];
                [self.tableView reloadData];
                //页码++
                self.pageNo++;
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                [self.tableView endRefreshingWithNoMoreData:NO];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"networkAbnormal")];
            [self.tableView endRefreshingWithNoMoreData:NO];
        }
    }];
}
- (NSMutableArray *)platformMessageArr {
    if (!_platformMessageArr) {
        _platformMessageArr = [NSMutableArray array];
    }
    return _platformMessageArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _platformMessageArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlatformMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlatformMessageCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PlatformMessageModel *model = _platformMessageArr[indexPath.row];
    cell.messageTitle.text = model.title;
    cell.messageCreateTime.text = model.updateDate;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlatformMessageModel *model = _platformMessageArr[indexPath.row];
    PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
    detailVC.content = model.content;
    detailVC.navtitle = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
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
