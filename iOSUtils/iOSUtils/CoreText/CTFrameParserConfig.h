//
//  CTFrameParserConfig.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextLinkData.h"
#import "CoreTextImageData.h"

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@property (strong, nonatomic) NSArray <CoreTextImageData *>* imageArray;              // 图片数组
@property (strong, nonatomic) NSArray <CoreTextLinkData *>* linkArray;                // 链接数组

@end
