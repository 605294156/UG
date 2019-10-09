//
//  UGHelpCenterViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGHelpCenterViewController.h"
#import "UGHelpCenterCell.h"

@interface UGHelpCenterViewController ()
@property (nonatomic,strong)NSArray *urlArray;
@end

@implementation UGHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGHelpCenterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGHelpCenterCell class])];
    self.dataSource = @[@"1、“交易” 规则", @"2、什么是支付密码？", @"3、什么是实名认证？", @"4、什么是高级认证？", @"5、什么是人脸识别？",@"6、两分钟入门视频"];
    NSString *str1= [UGURLConfig helpCenterApi:@"1"];
    NSString *str2=  [UGURLConfig helpCenterApi:@"2"];
//    NSString *str3= [UGURLConfig helpCenterApi:@"3"];
    NSString *str3= [UGURLConfig helpCenterApi:@"4"];
    NSString *str4= [UGURLConfig helpCenterApi:@"5"];
    NSString *str5= [UGURLConfig helpCenterApi:@"6"];
    NSString *str6= [NSString stringWithFormat:@" "];
    self.urlArray = @[str1,str2,str3,str4,str5,str6];
}

- (BOOL)hasHeadRefresh {
    return NO;
}

- (BOOL)hasFooterRefresh {
    return NO;
}

- (UITableViewStyle)getTableViewSytle {
    return UITableViewStyleGrouped;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGHelpCenterCell class]) forIndexPath:indexPath];
    [cell updateTitle:self.dataSource[indexPath.section]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource[indexPath.section] isEqualToString:@"6、两分钟入门视频"]) {
       [self playVideo];
    }else{
         [self gotoWebView:self.dataSource[indexPath.section] htmlUrl:self.urlArray[indexPath.section]];
    }
}
@end
