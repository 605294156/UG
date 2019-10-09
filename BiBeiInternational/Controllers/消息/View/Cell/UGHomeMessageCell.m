//
//  UGHomeMessageCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/22.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMessageCell.h"
#import "UGChatModel.h"
@interface UGHomeMessageCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bageW;
@property (weak, nonatomic) IBOutlet UILabel *bageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *systemMessage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;


@property (nonatomic, strong) UGChatModel *chatModel;

@end

@implementation UGHomeMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)useCustomStyle {
    return NO;
}

- (void)updateWithModel:(UGNotifyModel *)model WithBage:(NSInteger)bage{
    
    if ([model.parentMessageType isEqualToString:@"DYNAMIC_CHANGE_INFO"]) {
        self.systemMessage.text = @"动账消息";
    } else if (([model.parentMessageType isEqualToString:@"SYSTEM_CHANGE_INFO"])) {
        self.systemMessage.text =self.subMessageVC ? model.title : @"系统消息";
    } else if (([model.parentMessageType isEqualToString:@"INFORM_INFO"])) {
        self.systemMessage.text = @"通知消息";
    }
    self.content.text = model.alert;
    self.timeLabel.text = [UG_MethodsTool getFriendyWithStartTime:model.createTime];
    self.rightImg.hidden = NO;
    if(self.subMessageVC){
          self.imageIcon.image = [UIImage imageNamed:@"logo_cell_icon" ];
    }else{
        self.imageIcon.image = [model.parentMessageType isEqualToString:@"DYNAMIC_CHANGE_INFO"] ? [UIImage imageNamed:@"message_transfer" ] : ([model.parentMessageType isEqualToString:@"SYSTEM_CHANGE_INFO"] ? [UIImage imageNamed:@"news_icon"] : [UIImage imageNamed:@"message_notify"]);
    }
  
  [self updateBageNumber:bage];
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


- (void)dealloc {
    if (self.chatModel) {
        [self.chatModel bk_removeAllBlockObservers];
    }
}

@end
