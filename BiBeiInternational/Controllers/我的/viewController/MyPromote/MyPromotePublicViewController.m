//
//  MyPromotePublicViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyPromotePublicViewController.h"
#import "PromoteFriendsTableViewCell.h"
#import "MyCommissionTableViewCell.h"
#import "MineNetManager.h"
#import "PromoteFriendsModel.h"
#import "MyCommissionModel.h"

@interface MyPromotePublicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MyPromotePublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     [self.tableView registerNib:[UINib nibWithNibName:@"PromoteFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PromoteFriendsTableViewCell class])];
     [self.tableView registerNib:[UINib nibWithNibName:@"MyCommissionTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyCommissionTableViewCell class])];
    self.dataArr = [[NSMutableArray alloc] init];
    NSArray *tipArr = @[LocalizationKey(@"noPromoteFriends"),LocalizationKey(@"noMyCommission")];
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:tipArr[_index] detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [self.dataArr removeAllObjects];
    if (_index == 0) {
        //推广好友
        [MineNetManager getPromoteFriendsForCompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            NSLog(@"--%@",resPonseObj);
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    NSArray *dataArr = [PromoteFriendsModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                    [self.dataArr addObjectsFromArray:dataArr];
                    [self.tableView reloadData];
                   
                }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                    [[UGManager shareInstance] signout:nil];
                }else{
                    [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                }
            }else{
                [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
            }
        }];
        
    }else{
        //我的佣金
        [MineNetManager getMyCommissionForCompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            NSLog(@"--%@",resPonseObj);
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    NSArray *dataArr = [MyCommissionModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                    [self.dataArr addObjectsFromArray:dataArr];
                    [self.tableView reloadData];
                    
                }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){                   
                    [[UGManager shareInstance] signout:nil];
                }else{
                     [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                }
            }else{
               [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
            }
        }];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        //推广好友
        PromoteFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PromoteFriendsTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PromoteFriendsModel *model = self.dataArr[indexPath.row];
        cell.registerTime.text = model.createTime;
        cell.userName.text = model.username;
        if ([model.level isEqualToString:@"0"]) {
            cell.recommendedLevel.text = LocalizationKey(@"oneLevel");
        }else if ([model.level isEqualToString:@"1"]){
            cell.recommendedLevel.text = LocalizationKey(@"twoLevel");
        }else if ([model.level isEqualToString:@"2"]){
            cell.recommendedLevel.text = LocalizationKey(@"threeLevel");
        }else{
            cell.recommendedLevel.text = LocalizationKey(@"fourLevel");
        }
        return cell;
    }else{
        //我的佣金
        MyCommissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCommissionTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MyCommissionModel *model = self.dataArr[indexPath.row];
        cell.issueTime.text = model.createTime;
        cell.coinType.text = model.symbol;
        cell.remark.text = model.remark;
        cell.cash.text = [ToolUtil formartScientificNotationWithString:model.amount];
         
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_index == 0) {
        return 90;
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
