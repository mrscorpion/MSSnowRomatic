//
//  RainViewController.m
//  xuehua
//
//  Created by mrscorpion on 16/6/12.
//  Copyright © 2016年 mrscorpion. All rights reserved.
//

#import "RainViewController.h"
#import "WindRain.h"

@interface RainViewController ()

@property (nonatomic, strong) WindRain *rr;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation RainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.frame];
//    iv.image = [UIImage imageNamed:@"bk"];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:iv];
    _rr = [[WindRain alloc] initWithFrame:self.view.frame];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 2; i < 28; ++i) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"s%d", i]]];
    }
    
    [self showGif];
    
    //优化，计算出最大值，当y值超过最大值时没必要进入循环
    CGFloat maxY = 0;
    CGFloat minY = 700;
    for (NSValue *v in _points) {
        if ([v CGPointValue].y > maxY) {
            maxY = [v CGPointValue].y;
        }
        if ([v CGPointValue].y < minY) {
            minY = [v CGPointValue].y;
        }
    }
    
    _rr.rainMaxTime = 40;
    _rr.rainMinTime = 20;
    _rr.rainMaxCount = 14;
    _rr.rainMinCount = 10;
    _rr.imgs = [arr copy];
    [_rr whenClicked:^(UIButton *btn, WindRain *windRain) {
        [self showGif];
    }];
    
    [_rr whenMoved:^(UIButton *btn, WindRain *windRain) {
        //有点消耗性能，卡顿.优化
        dispatch_queue_t q = dispatch_queue_create("sdasdas", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(q, ^{
//            if (btn.center.y > minY && btn.center.y < maxY) {
                CGPoint tmp;
                CGPoint stopP;
                for (int i = 0; i < _points.count; ++i) {
                    if (!btn) {
                        break;
                    }
                    
                    tmp = [_points[i] CGPointValue];
                    stopP = CGPointMake(tmp.x, tmp.y + 220);
//                    if (CGRectContainsPoint(CGRectMake(btn.frame.origin.x - 100, btn.frame.origin.y - 100, 200, 200), stopP)) {
                    if (pow(btn.center.x - tmp.x, 2) + pow(btn.center.y - tmp.y, 2) < 10000) {
                        [_points removeObjectAtIndex:i];
                        
                        //雪花停止
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIView animateWithDuration:0.5 animations:^{
                                CGRect frame = btn.frame;
                                frame.size.width = 10;
                                frame.size.height = 10;
                                btn.frame = frame;
                                btn.center = stopP;
                            }];
                            [windRain stopMove:btn];
                            
                        });

                    break;
                    }
                }
                
                if (_points.count < 100) {
                    _rr.rainMaxCount = 8;
                    _rr.rainMinCount = 4;
                }
//            }

        });
        
    }];
    
    [self.view addSubview:_rr];
    [_rr setupTimer];
}

- (void)showGif {
    if (!_webView) {
        CGSize size = [UIImage imageNamed:@"lm.gif"].size;
        
        CGRect frame = CGRectMake((self.view.frame.size.width - size.width) / 2, 50, size.width, size.height);
        
        // 读取gif图片数据
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"lm" ofType:@"gif"]];
        // view生成
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.userInteractionEnabled = NO;//用户不可交互
        [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        _webView = webView;
        _webView.hidden = YES;
        [self.view addSubview:webView];
    }
    
    if (_webView.hidden) {
        _webView.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _webView.hidden = YES;
        });
    }
}

@end
