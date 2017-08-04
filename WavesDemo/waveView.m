//
//  waveView.m
//  WavesDemo
//
//  Created by Zeus on 2017/8/4.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import "waveView.h"

@interface waveView ()

// CADisplayLink的对象也是一个定时器。适用于UI的不停刷新，如自定义动画引擎或者视频的渲染。CADisplayLink 对象注册到Runloop之后。屏幕刷新的时候定时器就会被触发。ios设备的刷新频率是60HZ也就是60帧也就是每秒刷新60次，也可以通过设置frameInterval属性为2那么两帧才会刷新一次。
@property(nonatomic, strong)CADisplayLink *displayLink;

//CAShapeLayer 的对象是一个本身没有形状，他的形状来源于你给定的Path，它依附于path,所以必须给定path，即使path不完整也会自动收尾相接，strokeStart以及stroleEnd代表着这个path中所占的百分比（可以使用storkeStart和stroleEnd来做曲线进度的动画）。

@property(nonatomic, strong)CAShapeLayer *waveLayer1;

@property(nonatomic, strong)CAShapeLayer *waveLayer2;

// 正弦曲线 y =Asin（ωx+φ）+C
@property(nonatomic, assign)CGFloat waveA; // 振幅A

@property(nonatomic, assign)CGFloat wavew; // 周期（角速度）ω

@property(nonatomic, assign)CGFloat offsetX; // X轴偏距，初相 φ

@property(nonatomic, assign)CGFloat offsetY; // Y轴偏移 C

@property(nonatomic, assign)CGFloat waveSpeed; // 波浪流动的速度（曲线的移动速度）

@property(nonatomic, assign)CGFloat waveWidth; // 水纹的宽度



@end

@implementation waveView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupData];
    }
    return self;
}



- (void)setupUI
{
    
    // 下层
    // 初始化CASHapeLayer
    self.waveLayer1 = [CAShapeLayer layer];
    // 设置闭环的颜色
    self.waveLayer1.fillColor = ([UIColor cyanColor].CGColor);
    // 设置边缘线的颜色
    self.waveLayer1.strokeColor = [UIColor redColor].CGColor;
    // 设置边缘线的宽度
    self.waveLayer1.lineWidth = 2;
    [self.layer addSublayer:self.waveLayer1];
    
    
       
    // 上层
    self.waveLayer2 = [CAShapeLayer layer];
    self.waveLayer2.fillColor = [UIColor cyanColor].CGColor;
    self.waveLayer2.strokeColor = [UIColor blueColor].CGColor;
    self.waveLayer2.lineWidth = 2;
    [self.layer addSublayer:self.waveLayer2];
    
    // 画圆
    self.layer.cornerRadius = self.bounds.size.width/2.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 2;
    self.backgroundColor = [UIColor whiteColor];
    

}

#pragma mark --- 初始化数据 ----
- (void)setupData
{
    // 振幅
    self.waveA = 10.0;
    // 角速度
    self.wavew = 1/(M_PI*25);
    // 初相
    self.offsetX = 0;
    // Y轴偏移
    self.offsetY = self.bounds.size.height/2;
    // 曲线的移动速度
    self.waveSpeed = 0.05;
    // 以屏幕刷新的速度为周期刷新曲线的位置
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshWave:)];
    //启动定时器
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

// 刷新:  保持和屏幕的刷新速度相同，iphone的刷新速度是60Hz,即每秒60次的刷新
- (void)refreshWave:(CADisplayLink *)link
{
    // 更新X轴
    self.offsetX += self.waveSpeed;

    // 更新底层
    [self refreshWave1];
    // 更新上层
    [self refreshWave2];
}


// 更新下层
- (void)refreshWave1
{
    // 波浪宽度
    self.waveWidth = self.bounds.size.width;
    // 初始化运动轨迹
    CGMutablePathRef path = CGPathCreateMutable();
    //将点移动到 x = 0,y = self.offsetY的位置
    CGPathMoveToPoint(path, nil, 0, self.offsetY);
    // 设置初始Y为偏距
    CGFloat y = self.offsetY;
    // 正弦函数 y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= self.waveWidth; x++)
    {
        y = self.waveA * sin(self.wavew * x + self.offsetX ) + self.offsetY;
        // 将点连成线
        CGPathAddLineToPoint(path, nil, x, y);
    }
    // 填充底部的颜色
    CGPathAddLineToPoint(path, nil, self.waveWidth, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    self.waveLayer1.path = path;
    CGPathRelease(path);
    
}

// 更新上层
- (void)refreshWave2
{
    // 波浪宽度
    self.waveWidth = self.bounds.size.width;
    // 初始化运动轨迹
    CGMutablePathRef path = CGPathCreateMutable();
    //将点移动到 x = 0,y = self.offsetY的位置
    CGPathMoveToPoint(path, nil, 0, self.offsetY);
    // 设置初始Y为偏距
    CGFloat y = self.offsetY;
    // 正弦函数 y=Acos(ωx+φ)+k;
    for (float x = 0.0f; x <= self.waveWidth; x++)
    {
        y = self.waveA * cos(self.wavew * x + self.offsetX) + self.offsetY;
        // 将点连成线
        CGPathAddLineToPoint(path, nil, x, y);
    }
    // 填充底部的颜色
    CGPathAddLineToPoint(path, nil, self.waveWidth, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    self.waveLayer2.path = path;
    CGPathRelease(path);
    
}


- (void)dealloc
{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    if (self.waveLayer1) {
        [self.waveLayer1 removeFromSuperlayer];
        self.waveLayer1 = nil;
    }
    
    if (self.waveLayer2) {
        [self.waveLayer2 removeFromSuperlayer];
        self.waveLayer2 = nil;
    }
}




@end







