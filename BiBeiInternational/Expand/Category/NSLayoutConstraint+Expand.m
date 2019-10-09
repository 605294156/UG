//
//  NSLayoutConstraint+Expand.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "NSLayoutConstraint+Expand.h"

@implementation NSLayoutConstraint (Expand)


- (void)ug_changeMultiplier:(CGFloat)multiplier {
    [NSLayoutConstraint deactivateConstraints:@[self]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:multiplier constant:self.constant];
    newConstraint.priority = self.priority;
    newConstraint.shouldBeArchived = self.shouldBeArchived;
    newConstraint.identifier = self.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
}

@end
