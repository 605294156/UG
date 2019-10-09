//
//  TRFilterInputCollectionViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TRFilterInputCollectionViewCell.h"

@interface TRFilterInputCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UITextField *minTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@end

@implementation TRFilterInputCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setChooseDataModel:(MoreChooseDataModel *)chooseDataModel {
    _chooseDataModel = chooseDataModel;
    
    self.minTextFiled.placeholder = chooseDataModel.minPlaceholder;
    self.maxTextField.placeholder = chooseDataModel.maxPlaceholder;
    
    self.minTextFiled.text = chooseDataModel.minString;
    self.maxTextField.text = chooseDataModel.maxString;
    
    
    @weakify(self);
    [chooseDataModel bk_addObserverForKeyPaths:@[@"minString", @"maxString"] options:NSKeyValueObservingOptionNew task:^(MoreChooseDataModel *obj, NSString *keyPath, NSDictionary *change) {
        @strongify(self);
        self.minTextFiled.text = obj.minString;;
        self.maxTextField.text = obj.maxString;
    }];

//    UIColor *placeholederColor = [UIColor colorWithHexString:@"7EC9FF"];
//    [self.minTextFiled setValue:placeholederColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.maxTextField setValue:placeholederColor forKeyPath:@"_placeholderLabel.textColor"];

}

- (void)textFieldValueChange:(NSNotification *)notification {
    UITextField *inputTextField = notification.object;
    if (inputTextField == self.minTextFiled) {
        self.chooseDataModel.minString = inputTextField.text;
    } else if (inputTextField == self.maxTextField) {
        self.chooseDataModel.maxString = inputTextField.text;
    }
}

- (void)dealloc {
    [self.chooseDataModel bk_removeAllBlockObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
