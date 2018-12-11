//
//  CTFrameParser.m
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import "CTFrameParser.h"

typedef enum CTContentType : NSInteger {
    CTContentTypeText,     // 文本
    CTContentTypeLink,     // 链接
    CTContentTypeImage     // 图片
}CTContentType;

@implementation CTFrameParser

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+ (CoreTextData *)parseCoreDataWithString:(NSString*)contentString config:(CTFrameParserConfig*)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadAttributeWithString:contentString config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (NSAttributedString *)loadAttributeWithString:(NSString *)contentString config:(CTFrameParserConfig*)config
                              imageArray:(NSMutableArray *)imageArray
                                      linkArray:(NSMutableArray *)linkArray{
    NSAttributedString *contentAttr = [[NSAttributedString alloc]initWithString:contentString];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString:contentAttr];
    if ([config.imageArray isKindOfClass:[NSArray class]]) {
        for (CoreTextImageData *imgData in config.imageArray) {
            NSRange imgRange = [result.string rangeOfString:imgData.name];
            if(imgData.name && imgRange.location != NSNotFound){
                // 创建 CoreTextImageData
                imgData.position = (int)imgRange.location;
                [imageArray addObject:imgData];
                // 创建空白占位符，并且设置它的CTRunDelegate信息
                NSDictionary *dict = @{
                                       @"height" : @50,
                                       @"width": @50
                    };
                if(imgData.size.width != 0 && imgData.size.height != 0){
                    dict = @{
                             @"height" : @(imgData.size.height),
                             @"width": @(imgData.size.width)
                             };
                }
                NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                // 图片进行替换
                [result replaceCharactersInRange:imgRange withAttributedString:as];
            }
        }
    }
    if ([config.linkArray isKindOfClass:[NSArray class]]) {
        for (CoreTextLinkData *linkData in config.linkArray) {
            NSRange urlRange = [result.string rangeOfString:linkData.url];
            if(linkData.title && urlRange.location != NSNotFound){
                // 获取链接配置
                NSAttributedString *as = [self parseAttributedContentFromContent:linkData contentType:CTContentTypeLink config:config];
                // 链接进行替换
                [result replaceCharactersInRange:urlRange withAttributedString:as];
            }
        }
        // 图片和文字排版完后进行链接文字更新
        for (CoreTextLinkData *linkData in config.linkArray) {
            if(linkData.title){
                // 更新range
                NSRange titleRange = [result.string rangeOfString:linkData.title];
                // 创建 CoreTextLinkData
                linkData.range = titleRange;
                [linkArray addObject:linkData];
            }
        }
    }
    return result;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;
    
    // 释放内存
    CFRelease(framesetter);
//    CFRelease(frame);
    return data;
}


+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(CTFrameParserConfig *)config
                                  height:(CGFloat)height {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(CTFrameParserConfig*)config {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(dict));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (NSAttributedString *)parseAttributedContentFromContent:(id)contentData contentType: (CTContentType)contentType
                                                        config:(CTFrameParserConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = [self colorFromType:contentType];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    CGFloat fontSize = 0;
    if(contentType == CTContentTypeLink){
        fontSize = ((CoreTextLinkData*)contentData).fontSize;
    }
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content;
    if(contentType == CTContentTypeLink){
        content = ((CoreTextLinkData*)contentData).title;
    }
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (UIColor *)colorFromType:(CTContentType)contentType {
    if (contentType == CTContentTypeLink) {
        return [UIColor blueColor];
    } else if (contentType == CTContentTypeText) {
        return [UIColor redColor];
    } else if (contentType == CTContentTypeImage) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
}

@end
