//
//  UGSelectStateViewController.m
//  BiBeiInternational
//
//  Created by XiaoCheng on 26/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSelectStateViewController.h"
#import "StateTableViewCell.h"

@interface UGSelectStateViewController ()

@end

@implementation UGSelectStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择国家或地区";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.areaTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateTableViewCell0"];
    cell.model = self.areaTitles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.model = self.areaTitles[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
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
