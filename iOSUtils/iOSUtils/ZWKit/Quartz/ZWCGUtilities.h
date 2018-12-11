//
//  ZWCGUtilities.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/10.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/// Get main screen's scale.
CGFloat ZWScreenScale(void);

/// Get main screen's size. Height is always larger than width.
CGSize ZWScreenSize(void);

/**
 * 创建ARGB位图参数创建上下文
 * @params size 大小,opaque 灰度通道,scale 比例大小
 */
CGContextRef _Nullable ZWCGContextCreateARGBBitmapContext(CGSize size, BOOL opaque, CGFloat scale);


/**
 * 创建灰度位图参数创建上下文
 * @params size 大小,scale 比例大小
 */
CGContextRef _Nullable ZWCGContextCreateGrayBitmapContext(CGSize size, CGFloat scale);

/**
 * 角度转弧度
 * Convert degrees to radians.
 * @params degrees 角度
 */
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/**
 * 弧度转角度
 * Convert radians to degrees.
 * @params radians 弧度
 */
static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

/// Get the transform rotation.
/// @return the rotation in radians [-PI,PI] ([-180°,180°])
static inline CGFloat CGAffineTransformGetRotation(CGAffineTransform transform) {
    return atan2(transform.b, transform.a);
}

/// Get the transform's scale.x
static inline CGFloat CGAffineTransformGetScaleX(CGAffineTransform transform) {
    return  sqrt(transform.a * transform.a + transform.c * transform.c);
}

/// Get the transform's scale.y
static inline CGFloat CGAffineTransformGetScaleY(CGAffineTransform transform) {
    return sqrt(transform.b * transform.b + transform.d * transform.d);
}

/// Get the transform's translate.x
static inline CGFloat CGAffineTransformGetTranslateX(CGAffineTransform transform) {
    return transform.tx;
}

/// Get the transform's translate.y
static inline CGFloat CGAffineTransformGetTranslateY(CGAffineTransform transform) {
    return transform.ty;
}

/**
 If you have 3 pair of points transformed by a same CGAffineTransform:
 p1 (transform->) q1
 p2 (transform->) q2
 p3 (transform->) q3
 This method returns the original transform matrix from these 3 pair of points.
 
 @see http://stackoverflow.com/questions/13291796/calculate-values-for-a-cgaffinetransform-from-three-points-in-each-of-two-uiview
 */
CGAffineTransform ZWCGAffineTransformGetFromPoints(CGPoint before[3], CGPoint after[3]);

/// Get the transform which can converts a point from the coordinate system of a given view to another.
CGAffineTransform ZWCGAffineTransformGetFromViews(UIView *from, UIView *to);

/// Create a skew transform.
static inline CGAffineTransform CGAffineTransformMakeSkew(CGFloat x, CGFloat y){
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}

/// Negates/inverts a UIEdgeInsets.
static inline UIEdgeInsets UIEdgeInsetsInvert(UIEdgeInsets insets) {
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}

/// Convert CALayer's gravity string to UIViewContentMode.
UIViewContentMode ZWCAGravityToUIViewContentMode(NSString *gravity);

/// Convert UIViewContentMode to CALayer's gravity string.
NSString *ZWUIViewContentModeToCAGravity(UIViewContentMode contentMode);



/**
 Returns a rectangle to fit the @param rect with specified content mode.
 
 @param rect The constrant rect
 @param size The content size
 @param mode The content mode
 @return A rectangle for the given content mode.
 @discussion UIViewContentModeRedraw is same as UIViewContentModeScaleToFill.
 */
CGRect ZWCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

/// Returns the center for the rectangle.
static inline CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/// Returns the area of the rectangle.
static inline CGFloat CGRectGetArea(CGRect rect) {
    if (CGRectIsNull(rect)) return 0;
    rect = CGRectStandardize(rect);
    return rect.size.width * rect.size.height;
}

/// Returns the distance between two points.
static inline CGFloat CGPointGetDistanceToPoint(CGPoint p1, CGPoint p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

/// Returns the minmium distance between a point to a rectangle.
static inline CGFloat CGPointGetDistanceToRect(CGPoint p, CGRect r) {
    r = CGRectStandardize(r);
    if (CGRectContainsPoint(r, p)) return 0;
    CGFloat distV, distH;
    if (CGRectGetMinY(r) <= p.y && p.y <= CGRectGetMaxY(r)) {
        distV = 0;
    } else {
        distV = p.y < CGRectGetMinY(r) ? CGRectGetMinY(r) - p.y : p.y - CGRectGetMaxY(r);
    }
    if (CGRectGetMinX(r) <= p.x && p.x <= CGRectGetMaxX(r)) {
        distH = 0;
    } else {
        distH = p.x < CGRectGetMinX(r) ? CGRectGetMinX(r) - p.x : p.x - CGRectGetMaxX(r);
    }
    return MAX(distV, distH);
}


/// Convert point to pixel.
static inline CGFloat CGFloatToPixel(CGFloat value) {
    return value * ZWScreenScale();
}

/// Convert pixel to point.
static inline CGFloat CGFloatFromPixel(CGFloat value) {
    return value / ZWScreenScale();
}



/// floor point value for pixel-aligned
static inline CGFloat CGFloatPixelFloor(CGFloat value) {
    CGFloat scale = ZWScreenScale();
    return floor(value * scale) / scale;
}

/// round point value for pixel-aligned
static inline CGFloat CGFloatPixelRound(CGFloat value) {
    CGFloat scale = ZWScreenScale();
    return round(value * scale) / scale;
}

/// ceil point value for pixel-aligned
static inline CGFloat CGFloatPixelCeil(CGFloat value) {
    CGFloat scale = ZWScreenScale();
    return ceil(value * scale) / scale;
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGFloat CGFloatPixelHalf(CGFloat value) {
    CGFloat scale = ZWScreenScale();
    return (floor(value * scale) + 0.5) / scale;
}



/// floor point value for pixel-aligned
static inline CGPoint CGPointPixelFloor(CGPoint point) {
    CGFloat scale = ZWScreenScale();
    return CGPointMake(floor(point.x * scale) / scale,
                       floor(point.y * scale) / scale);
}

/// round point value for pixel-aligned
static inline CGPoint CGPointPixelRound(CGPoint point) {
    CGFloat scale = ZWScreenScale();
    return CGPointMake(round(point.x * scale) / scale,
                       round(point.y * scale) / scale);
}

/// ceil point value for pixel-aligned
static inline CGPoint CGPointPixelCeil(CGPoint point) {
    CGFloat scale = ZWScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale,
                       ceil(point.y * scale) / scale);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGPoint CGPointPixelHalf(CGPoint point) {
    CGFloat scale = ZWScreenScale();
    return CGPointMake((floor(point.x * scale) + 0.5) / scale,
                       (floor(point.y * scale) + 0.5) / scale);
}



/// floor point value for pixel-aligned
static inline CGSize CGSizePixelFloor(CGSize size) {
    CGFloat scale = ZWScreenScale();
    return CGSizeMake(floor(size.width * scale) / scale,
                      floor(size.height * scale) / scale);
}

/// round point value for pixel-aligned
static inline CGSize CGSizePixelRound(CGSize size) {
    CGFloat scale = ZWScreenScale();
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

/// ceil point value for pixel-aligned
static inline CGSize CGSizePixelCeil(CGSize size) {
    CGFloat scale = ZWScreenScale();
    return CGSizeMake(ceil(size.width * scale) / scale,
                      ceil(size.height * scale) / scale);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGSize CGSizePixelHalf(CGSize size) {
    CGFloat scale = ZWScreenScale();
    return CGSizeMake((floor(size.width * scale) + 0.5) / scale,
                      (floor(size.height * scale) + 0.5) / scale);
}

/// floor point value for pixel-aligned
static inline CGRect CGRectPixelFloor(CGRect rect) {
    CGPoint origin = CGPointPixelCeil(rect.origin);
    CGPoint corner = CGPointPixelFloor(CGPointMake(rect.origin.x + rect.size.width,
                                                   rect.origin.y + rect.size.height));
    CGRect ret = CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
    if (ret.size.width < 0) ret.size.width = 0;
    if (ret.size.height < 0) ret.size.height = 0;
    return ret;
}

/// round point value for pixel-aligned
static inline CGRect CGRectPixelRound(CGRect rect) {
    CGPoint origin = CGPointPixelRound(rect.origin);
    CGPoint corner = CGPointPixelRound(CGPointMake(rect.origin.x + rect.size.width,
                                                   rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// ceil point value for pixel-aligned
static inline CGRect CGRectPixelCeil(CGRect rect) {
    CGPoint origin = CGPointPixelFloor(rect.origin);
    CGPoint corner = CGPointPixelCeil(CGPointMake(rect.origin.x + rect.size.width,
                                                  rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGRect CGRectPixelHalf(CGRect rect) {
    CGPoint origin = CGPointPixelHalf(rect.origin);
    CGPoint corner = CGPointPixelHalf(CGPointMake(rect.origin.x + rect.size.width,
                                                  rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// floor UIEdgeInset for pixel-aligned
static inline UIEdgeInsets UIEdgeInsetPixelFloor(UIEdgeInsets insets) {
    insets.top = CGFloatPixelFloor(insets.top);
    insets.left = CGFloatPixelFloor(insets.left);
    insets.bottom = CGFloatPixelFloor(insets.bottom);
    insets.right = CGFloatPixelFloor(insets.right);
    return insets;
}

/// ceil UIEdgeInset for pixel-aligned
static inline UIEdgeInsets UIEdgeInsetPixelCeil(UIEdgeInsets insets) {
    insets.top = CGFloatPixelCeil(insets.top);
    insets.left = CGFloatPixelCeil(insets.left);
    insets.bottom = CGFloatPixelCeil(insets.bottom);
    insets.right = CGFloatPixelCeil(insets.right);
    return insets;
}

// main screen's scale
#ifndef kScreenScale
#define kScreenScale ZWScreenScale()
#endif

// main screen's size (portrait)
#ifndef kScreenSize
#define kScreenSize ZWScreenSize()
#endif

// main screen's width (portrait)
#ifndef kScreenWidth
#define kScreenWidth ZWScreenSize().width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight ZWScreenSize().height
#endif


NS_ASSUME_NONNULL_END
