//
//  UGSchduleViewCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSchduleViewCell.h"

@interface UGSchduleViewCell ()
@property(strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@end


@implementation UGSchduleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UGOrderWaitingModel *)model{
    self.orderSnoLabel.text = [NSString stringWithFormat:@"订单号 %@",model.orderSn];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.userNameLabel.text = model.tradeUserName;
    self.typeLabel.text = [model.status isEqualToString:@"1"] ? @"购买" : @"出售";
    self.cnyLabel.text = [NSString stringWithFormat:@"%@ UG",[model.number ug_amountFormat]];
    [self.payBtn setTitle:[model.status isEqualToString:@"1"] ? @"去支付" : @"去放币" forState:UIControlStateNormal];
//    [self secondsCountDown:model];
}

- (IBAction)click:(id)sender {
    if (self.payClick) {
        self.payClick();
    }
}

- (BOOL)useCustomStyle{
    return NO;
}

#pragma mark - 倒计时剩余支付时间
- (void)secondsCountDown:(UGOrderWaitingModel *)model {
    __block int timeout = [model.timeLimit intValue];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout<0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                //                self.confirmButton.enabled = NO;
            });
        }else {
            int minutes = timeout/60;
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%d : %d ", minutes, seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [NSString stringWithFormat:@"剩余 %@",strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end
