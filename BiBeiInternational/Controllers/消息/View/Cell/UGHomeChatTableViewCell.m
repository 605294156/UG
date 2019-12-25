//
//  UGHomeChatTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGHomeChatTableViewCell.h"

@interface UGHomeChatTableViewCell ()<SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bageW;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bageLabel;


@end

@implementation UGHomeChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundColor = [UIColor yellowColor];
//    self.layer.cornerRadius = 4;
//    self.layer.masksToBounds = YES;
//    self.contentView.backgroundColor = [UIColor orangeColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setFrame:(CGRect)frame {
//    static CGFloat margin = 14;
//    frame.origin.x = margin;
//    frame.size.width -= 2 * frame.origin.x;
//    [super setFrame:frame];
//}

- (NSArray *)sessionListCellRightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if ([self.chatModel.userName isEqualToString:@"在线客服"]) {
//        [rightUtilityButtons addObject:[self createUtilityButtonWithColor:[UIColor grayColor] title:@"清空记录"]];
    } else {
        [rightUtilityButtons addObject:[self createUtilityButtonWithColor:[UIColor grayColor] title:@"清空记录"]];
        [rightUtilityButtons addObject:[self createUtilityButtonWithColor:[UIColor redColor] title:@"删除"]];
    }
    return rightUtilityButtons;
}

- (UIButton *)createUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = color;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return button;
    
}


- (void)setChatModel:(UGChatModel *)chatModel {
    _chatModel = chatModel;
    self.bageLabel.hidden = YES;
    self.nameLabel.text = chatModel.userName;
    self.content.text = chatModel.content;
//    [self setRightUtilityButtons:[self sessionListCellRightButtons] WithButtonWidth:80];
    self.delegate = self;
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:chatModel.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.timeLabel.text = chatModel.timestamp;
    [self updateBageNumber:chatModel.unreadCount];
    
//    [self.chatModel.conversation bk_addObserverForKeyPath:@"unreadCount" options:NSKeyValueObservingOptionNew  task:^(JMSGConversation *conversation, NSDictionary *change) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateBageNumber:[conversation.unreadCount integerValue]];
//        });
//    }];
//
//    [self.chatModel bk_addObserverForKeyPath:@"content" options:NSKeyValueObservingOptionNew task:^(UGChatModel * chatModel, NSDictionary *change) {
//        self.content.text = chatModel.content;
//    }];
}

- (void)updateBageNumber:(NSInteger )bage {
    
    if (bage>0) {
        self.bageLabel.hidden = NO;
        if (bage>99) {
            self.bageW.constant = 28;
            self.bageLabel.text = [NSString stringWithFormat:@"99+"];
        }else{
            self.bageLabel.text = [NSString stringWithFormat:@"%zd",bage];
            if (bage>=10 && bage<99) {
                self.bageW.constant = 25;
            }
        }
    }else{
        self.bageLabel.hidden = YES;
    }
    
}


#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {    
    if (index == 0) { //清空聊天记录

    } else if (index == 1) {
         //删除会话回调出去处理
        NSString *chatUserName = [NSString stringWithFormat:@"%@%@",[UGManager shareInstance].hostInfo.userInfoModel.chatPrefix, self.chatModel.userName];

    }
}


- (void)dealloc {
    if (self.chatModel) {
        [self.chatModel bk_removeAllBlockObservers];
    }
}

@end
