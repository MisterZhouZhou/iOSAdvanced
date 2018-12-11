//
//  UITextField+ZWAdd.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/10.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UITextField`.
 */
@interface UITextField (ZWAdd)

/**
 * 选中所有的文字
 * Set all text selected.
 */
- (void)selectAllText;

/**
 * 根据范围选择文字
 * Set text in range selected.
 * @param range  The range of selected text in a document.
 */
- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
