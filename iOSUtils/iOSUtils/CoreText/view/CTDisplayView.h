//
//  CTDisplayView.h
//  iOSUtils
//
//  Created by zhouwei on 2018/12/11.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

extern NSString *const CTDisplayViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

@interface CTDisplayView : UIView

@property (strong, nonatomic) CoreTextData *data;

@end
