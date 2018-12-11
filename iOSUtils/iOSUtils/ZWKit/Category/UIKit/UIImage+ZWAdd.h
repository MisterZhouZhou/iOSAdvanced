//
//  UIImage+ZWAdd.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/10.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some commen method for `UIImage`.
 Image process is based on CoreGraphic and vImage.
 */
@interface UIImage (ZWAdd)

/**
 Create a square image from apple emoji.
 
 @discussion It creates a square image from apple emoji, image's scale is equal
 to current screen's scale. The original emoji image in `AppleColorEmoji` font
 is in size 160*160 px.
 
 @param emoji single emoji, such as @"😄".
 
 @param size  image's size.
 
 @return Image from emoji, or nil when an error occurs.
 */
+ (nullable UIImage *)imageWithEmoji:(NSString *)emoji size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
