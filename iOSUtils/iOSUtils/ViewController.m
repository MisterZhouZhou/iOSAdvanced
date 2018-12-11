//
//  ViewController.m
//  iOSUtils
//
//  Created by zhouwei on 2018/12/10.
//  Copyright © 2018年 zhouwei. All rights reserved.
//

#import "ViewController.h"
#import "ZWKit.h"
#import "TestView.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"
#import "UIView+ZWAdd.h"

@interface ViewController ()
{
    CTDisplayView *_displayView;
}
@end

@implementation ViewController{
    ZWTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _displayView = [[CTDisplayView alloc]initWithFrame:CGRectMake(10, 70, CGRectGetWidth(self.view.frame)-20, 300)];
    [self.view addSubview:_displayView];
    
    // 要显示的文字
    NSString *showText = @"coretext-image-2更进一步地，http://www.baidu.com实际http://www.baidu.com3工作中，我们更希望通过一个排版文件，来设置需要排版的文字的http://www.baidu.com2coretext-image-2";
//    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc]initWithString:showText];
    
//    NSString *baiduUrl = @"http://www.baidu.com";
//    [contentString appendAttributedString:[[NSAttributedString alloc]initWithString:baiduUrl]];
//
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    CoreTextLinkData *urlData = [CoreTextLinkData new];
    urlData.title = @"百度";
    urlData.url   = @"http://www.baidu.com";
    urlData.fontSize = 20;
    CoreTextLinkData *urlData2 = [CoreTextLinkData new];
    urlData2.title = @"百度2";
    urlData2.url   = @"http://www.baidu.com2";
    urlData2.fontSize = 14;
    CoreTextLinkData *urlData3 = [CoreTextLinkData new];
    urlData3.title = @"百度3";
    urlData3.url   = @"http://www.baidu.com3";
    urlData3.fontSize = 11;
    config.linkArray = @[urlData,urlData2,urlData3];
    
    CoreTextImageData *imgData = [CoreTextImageData new];
    imgData.name = @"coretext-image-2";
    imgData.size = CGSizeMake(100, 30);
    
    CoreTextImageData *imgData2 = [CoreTextImageData new];
    imgData2.name = @"coretext-image-2";
    imgData2.size = CGSizeMake(100, 60);
    config.imageArray = @[imgData,imgData2];
    
    config.width = CGRectGetWidth(_displayView.frame);
    CoreTextData *data = [CTFrameParser parseCoreDataWithString:showText config:config];
    _displayView.data = data;
    _displayView.height = data.height;
    _displayView.backgroundColor = [UIColor whiteColor];
    
     [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePressed:)
                                                 name:CTDisplayViewImagePressedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkPressed:)
                                                 name:CTDisplayViewLinkPressedNotification object:nil];
    
}

- (void)imagePressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"%@",userInfo);
//    CoreTextImageData *imageData = userInfo[@"imageData"];
//
//    ImageViewController *vc = [[ImageViewController alloc] init];
//    vc.image = [UIImage imageNamed:imageData.name];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)linkPressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CoreTextLinkData *linkData = userInfo[@"linkData"];
    NSLog(@"%@",linkData);

//    WebContentViewController *vc = [[WebContentViewController alloc] init];
//    vc.urlTitle = linkData.title;
//    vc.url = linkData.url;
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)test1 {
    TestView *imgv = [[TestView alloc]initWithFrame:CGRectMake(40, 100, 220, 220)];
    imgv.backgroundColor = [UIColor redColor];
    [self.view addSubview:imgv];
}

- (void)test {
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(40, 100, 50, 50)];
    imgv.image = [UIImage imageWithEmoji:@"😄" size:50];
    [self.view addSubview:imgv];
    
    _timer = [ZWTimer timerWithTimeInterval:2 target:self selector:@selector(action) repeats:YES];
}

- (void)action{
    NSLog(@"ddd");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
