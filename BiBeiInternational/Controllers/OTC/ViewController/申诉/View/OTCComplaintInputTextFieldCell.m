//
//  OTCComplaintInputTextFieldCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCComplaintInputTextFieldCell.h"

static NSString  * const MONEYNUMBERS = @"0123456789";

@interface OTCComplaintInputTextFieldCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation OTCComplaintInputTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intputTextChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)setModel:(OTCComplaintModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.textField.placeholder = model.placeholder;
    self.textField.text = model.value;
    @weakify(self);
    [model bk_addObserverForKeyPath:@"value" options:NSKeyValueObservingOptionNew task:^(OTCComplaintModel *obj, NSDictionary *change) {
        @strongify(self);
        self.textField.text = obj.value;
    }];
    [model bk_addObserverForKeyPath:@"title" options:NSKeyValueObservingOptionNew task:^(OTCComplaintModel *obj, NSDictionary *change) {
        @strongify(self);
        self.titleLabel.text = model.title;
    }];
}

- (void)intputTextChange:(NSNotification *)sender {
    if (sender.object == self.textField) {
        self.model.value = self.textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if ([self.model.title containsString:@"手机号"]) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        NSString *inputString = [textField.text stringByAppendingString:string];
        if (basicTest && inputString.length <= 20) {
            return YES;
        }
        return NO;
    }
    return NO;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //订单号、姓名 不让编辑
    if ([self.model.title containsString:@"订单"] || [self.model.title containsString:@"姓名"]) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
