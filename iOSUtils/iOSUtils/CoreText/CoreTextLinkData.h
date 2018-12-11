//
//  CoreTextLinkData.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextLinkData : NSObject

// --- 可配置 ---  //
@property (strong, nonatomic) NSString * title;   // 标题
@property (strong, nonatomic) NSString * url;     // url
@property (nonatomic, assign) CGFloat fontSize;   // 可以配置字体大小
// --- 可配置 ---  //

@property (assign, nonatomic) NSRange range;      // 范围

@end
