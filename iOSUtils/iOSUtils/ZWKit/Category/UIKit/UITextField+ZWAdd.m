//
//  UITextField+ZWAdd.m
//  iOSUtils
//
//  Created by zhouwei on 2018/12/10.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import "UITextField+ZWAdd.h"

@implementation UITextField (ZWAdd)

- (void)selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
