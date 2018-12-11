//
//  CoreTextData.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"


@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;                // frame
@property (assign, nonatomic) CGFloat height;                    // 高度
@property (strong, nonatomic) NSArray * imageArray;              // 图片数组
@property (strong, nonatomic) NSArray * linkArray;               // 链接数组
@property (strong, nonatomic) NSAttributedString *content;       // 富文本内容


@end
