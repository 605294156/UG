//
//  UGBindingGoogleVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBindingGoogleVC.h"
#import "UGGoogleStepOneCell.h"
#import "UGGoogleStepTwoCell.h"
#import "UGGoogleStepThreeCell.h"
#import "UGGoogleStepFourCell.h"
#import "UGShowGoogleVerifyVC.h"

#define UGGoogleStepOneCellIdentifier @"UGGoogleStepOneCell"
#define UGGoogleStepTwoCellIdentifier @"UGGoogleStepTwoCell"
#define UGGoogleStepThreeCellIdentifier @"UGGoogleStepThreeCell"
#define UGGoogleStepFourCellIdentifier @"UGGoogleStepFourCell"

@interface UGBindingGoogleVC ()

@end

@implementation UGBindingGoogleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGGoogleStepOneCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepOneCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGGoogleStepTwoCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepTwoCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGGoogleStepThreeCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepThreeCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGGoogleStepFourCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepFourCellIdentifier];
}

-(void)languageChange{
    self.title = @"绑定谷歌验证器";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UGGoogleStepOneCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepOneCellIdentifier forIndexPath:indexPath];
        cell.downLoadBlack = ^{
            //跳转到谷歌验证器下载页面
          [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/google-authenticator/id388497605"]];
        };
        return cell;
    }else if(indexPath.section == 1){
        UGGoogleStepTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepTwoCellIdentifier forIndexPath:indexPath];
        return cell;
    }else if(indexPath.section == 2){
        UGGoogleStepTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepThreeCellIdentifier forIndexPath:indexPath];
        return cell;
    }else if(indexPath.section == 3){
        UGGoogleStepFourCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepFourCellIdentifier forIndexPath:indexPath];
        cell.bindClick = ^{
          //立即绑定
            UGShowGoogleVerifyVC *vc = [[UGShowGoogleVerifyVC alloc] init];
            vc.baseVC = self.baseVC;
            vc.isCarvip = self.isCarvip;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0) {
        return 124;
    }
    else if(indexPath.section==1) {
        return 520;
    }
    else if(indexPath.section==2) {
        return 85;
    }
    else if(indexPath.section==3) {
        return 146;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(BOOL)hasHeadRefresh{
    return NO;
}

-(BOOL)hasFooterRefresh{
    return NO;
}
@end
