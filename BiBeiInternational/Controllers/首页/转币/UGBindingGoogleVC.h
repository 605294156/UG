//
//  UGBindingGoogleVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"

@interface UGBindingGoogleVC : UGBaseViewController

@property(nonatomic,strong)UIViewController *baseVC;
@property(nonatomic,assign)BOOL isCarvip;
@property(nonatomic,weak) IBOutlet UITableView *bgTableView;

@end
