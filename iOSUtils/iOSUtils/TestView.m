//
//  TestView.m
//  iOSUtils
//
//  Created by zhouwei on 2018/12/10.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import "TestView.h"
#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

static CGFloat ascentCallback(void * ref){
    return [(NSNumber*)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

-(void)drawRect:(CGRect)rect {

    // 文本添加链接
    
    
    
}



- (void)normalText {
    //    //  初始化一个画布
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    // 反转画布的坐标系，OS坐标原点在左下角，iOS坐标原点在左上角，所以需要做反转
    //    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    //    CGContextScaleCTM(context, 1.0, -1.0);
    //    // 设置文本的矩阵
    //    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //    // 创建文本范围的路径
    //    CGMutablePathRef path = CGPathCreateMutable();
    //    // 创建一个矩形文本区域, 坐标是反的
    //    CGRect bounds = CGRectMake(0.0, self.bounds.size.height - 100, 100.0, 100.0);
    //    CGPathAddRect(path, NULL, bounds);
    //    // 设置显示的文字
    //    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    //    //创建一个多属性字段，maxlength为0；maxlength是提示系统有需要多少内部空间需要保留，0表示不用提示限制
    //    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    //    //为attrString添加内容，也可以用CFAttributedStringCreate 开头的几个方法，根据不同的需要和参数选择合适的方法。这里用替换的方式，完成写入。
    //    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), textString);
    //    //为多属性字符串增添一个颜色的属性，这里就是奇妙之处，富文本的特点就在这里可以自由的调整文本的属性：比如，颜色，大小，字体，下划线，斜体，字间距，行间距等
    //    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    //    // 创建一个红色的对象
    //    CGFloat components[] = {0.0,1.0,0.0,0.8};
    //    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    //    // 内存回收
    //    CGColorSpaceRelease(rgbColorSpace);
    //    // 给前12个字符添加红色属性
    //    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12), kCTForegroundColorAttributeName, red);
    //    //kCTForegroundColorAttributeName,是CT定义的表示文本字体颜色的常量，类似的常量茫茫多，组成了编辑富文本的诸多属性。//通过多属性字符，可以得到一个文本显示范围的工厂对象，我们最后渲染文本对象是通过这个工厂对象进行的。这部分需要引入#import<CoreText/CoreText.h>
    //    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(attrString);
    //    // 获得要绘制的区域的高度
    //    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, bounds.size, nil);
    //    //真实文本内容的高度
    //    CGFloat textHeight = coreTextSize.height;
    //    CFRelease(attrString);
    //    // 创建一个有文本内容的范围
    //    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    //    // 把文本显示在给定的文本范围内
    //    CTFrameDraw(frame, context);
    //    CFRelease(frame);
    //    CFRelease(frameSetter);
    //    CFRelease(path);
    
}

- (void)suText {
    //  竖版文本绘制
    // 初始一个画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 反转画布
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1.0, -1.0);
    // 重置画布
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    // 获取段落绘制的工厂对象
    // 设置显示的文字
    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Sometimes I write one, and I look at it, until it begins to shine.Sometimes I write one, and I look at it, until it begins to shine.");
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, textString, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)currentText);
    // 获得3列的文本路径数组
    CFArrayRef columnPaths = [self createColumnsWithColumnCount:3];
    //开始一列一列绘制，就像一个个的段落
    CFIndex pathCount = CFArrayGetCount(columnPaths);
    CFIndex startIndex = 0;
    int column;
    for (column = 0; column<pathCount; column++) {
        CGPathRef path = (CGPathRef)CFArrayGetValueAtIndex(columnPaths, column);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        //每一列在文本中范围
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    CFRelease(columnPaths);
    CFRelease(currentText);
    CFRelease(framesetter);
}

- (CFArrayRef)createColumnsWithColumnCount: (NSInteger) columnCount {
    int column;
    // 创建了columnCount个react
    CGRect *columnRects = (CGRect*)calloc(columnCount, sizeof(*columnRects));
    columnRects[0] = self.bounds;//第一列覆盖整个view,为下面循环得到列的rect做准备
    //把view的宽按照列数平分,当然你也可以自定义不用平分
    CGFloat columnWidth = CGRectGetWidth(self.bounds)/columnCount;
    for (column = 0; column<columnCount-1; column++) {
        //得到每一列的Rect，自动存在数组中
        CGRectDivide(columnRects[column], &columnRects[column], &columnRects[column+1], columnWidth, CGRectMinXEdge);
    }
    //给所有列增加几个像素的边距
    for (column = 0; column<columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column],8.0,15.0);//8.0表示水平边距，15.0表示纵向边距。
    }
    //创建一个数组，每一列的布局路径
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, columnCount, &kCFTypeArrayCallBacks);
    for (column=0; column<columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    // 请求指针
    free(columnRects);
    return array;
}

@end
