//
//  CoreTextImageData.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreTextImageData : NSObject
// --- 可配置 ---  //
@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) CGSize size;
// --- 可配置 ---  //

@property (assign, nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (assign, nonatomic) CGRect imagePosition;

@end
