//
//  ViewController.m
//  MSSnowRomatic
//
//  Created by mrscorpion on 16/6/12.
//  Copyright © 2016年 mrscorpion. All rights reserved.
//

#import "ViewController.h"
#import "YQPant.h"
#import "RainViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet YQPant *pantView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)action_cancle:(UIButton *)sender {
    [_pantView back];
}

- (IBAction)action_save:(UIButton *)sender {
    [_pantView save];
    
}

- (IBAction)action_next:(UIButton *)sender {
    RainViewController *rvc = [[RainViewController alloc] init];
    rvc.points = [_pantView readData];
    [self presentViewController:rvc animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
