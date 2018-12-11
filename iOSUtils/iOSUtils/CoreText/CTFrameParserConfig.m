//
//  CTFrameParserConfig.m
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 0.0f;
        _textColor = [UIColor lightGrayColor];
//        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
