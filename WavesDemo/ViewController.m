//
//  ViewController.m
//  WavesDemo
//
//  Created by Zeus on 2017/8/4.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import "ViewController.h"
#import "waveView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    waveView *aview = [[waveView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    [self.view addSubview:aview];
    
    
}





@end
