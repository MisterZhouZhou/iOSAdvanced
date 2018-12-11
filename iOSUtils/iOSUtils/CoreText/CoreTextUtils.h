//
//  CoreTextUtils.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextLinkData.h"
#import "CoreTextData.h"

@interface CoreTextUtils : NSObject

// 检测点击位置是否在链接上
+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
