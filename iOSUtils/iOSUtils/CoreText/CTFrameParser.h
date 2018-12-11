//
//  CTFrameParser.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

@interface CTFrameParser : NSObject

+ (CoreTextData *)parseCoreDataWithString:(NSString*)contentString config:(CTFrameParserConfig*)config;

@end
