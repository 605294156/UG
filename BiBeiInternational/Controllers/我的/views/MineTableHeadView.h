//
//  MineTableHeadView.h
//  ATC
//
//  Created by iDog on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headButton;//头像的点击按钮
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *userName;//昵称
@property (weak, nonatomic) IBOutlet UILabel *account; //账号
@property (weak, nonatomic) IBOutlet UILabel *totalAssets; //总资产
@property (weak, nonatomic) IBOutlet UILabel *asset1; //资产 橙色数字
@property (weak, nonatomic) IBOutlet UILabel *asset2; //资产 换算数字
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;  //眼睛按钮
@property (weak, nonatomic) IBOutlet UIButton *assetButton;//资产按钮
-(MineTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect;
@end
