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
    self.navigationBarHidden = YES;
//    self.view.backgroundColor = [UIColor colorWithHexString:@"3f5994"];
    if ([self.bgTableView respondsToSelector:@selector(setSeparatorInset:)]) {

        [self.bgTableView setSeparatorInset:UIEdgeInsetsZero];

    }
    if (@available(*,iOS 11)) {
        self.bgTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    [self languageChange];
//
//    [self.bgTableView registerNib:[UINib nibWithNibName:@"UGGoogleStepOneCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepOneCellIdentifier];
//
//    [self.bgTableView registerNib:[UINib nibWithNibName:@"UGGoogleStepTwoCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepTwoCellIdentifier];
//
//    [self.bgTableView registerNib:[UINib nibWithNibName:@"UGGoogleStepThreeCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepThreeCellIdentifier];
//
//    [self.bgTableView registerNib:[UINib nibWithNibName:@"UGGoogleStepFourCell" bundle:nil] forCellReuseIdentifier:UGGoogleStepFourCellIdentifier];
}

-(void)languageChange{
    self.title = @"绑定谷歌验证器";
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UGGoogleStepOneCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepOneCellIdentifier];
        if (!cell) {
            cell =  [[NSBundle mainBundle]loadNibNamed:@"UGGoogleStepOneCell" owner:self options:nil].firstObject;
        }
        cell.downLoadBlack = ^{
            //跳转到谷歌验证器下载页面
          [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/google-authenticator/id388497605"]];
        };
        return cell;
    }else if(indexPath.row == 1){
        UGGoogleStepTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepTwoCellIdentifier];
        if (!cell) {
            cell =  [[NSBundle mainBundle]loadNibNamed:@"UGGoogleStepTwoCell" owner:self options:nil].firstObject;
        }
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:cell.oneLabel.text];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"6684c7"] range:NSMakeRange(3, 6)];
        cell.oneLabel.attributedText = str1;
        
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:cell.twoLabel.text];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"6684c7"] range:NSMakeRange(3, 9)];
        cell.twoLabel.attributedText = str2;
        return cell;
    }else if(indexPath.row == 2){
        UGGoogleStepThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepThreeCellIdentifier];
        if (!cell) {
            cell =  [[NSBundle mainBundle]loadNibNamed:@"UGGoogleStepThreeCell" owner:self options:nil].firstObject;
        }
        return cell;
    }else if(indexPath.row == 3){
        UGGoogleStepFourCell *cell = [tableView dequeueReusableCellWithIdentifier:UGGoogleStepFourCellIdentifier];
        if (!cell) {
            cell =  [[NSBundle mainBundle]loadNibNamed:@"UGGoogleStepFourCell" owner:self options:nil].firstObject;
        }
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
    if(indexPath.row ==0) {
        return 306;
    }
    else if(indexPath.row ==1) {
        return 392;
    }
    else if(indexPath.row ==2) {
        return 297;
    }
    else if(indexPath.row ==3) {
        return 170;
    }
    return 0;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [UIView new];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10.0f;
//}

-(BOOL)hasHeadRefresh{
    return NO;
}

-(BOOL)hasFooterRefresh{
    return NO;
}
@end
