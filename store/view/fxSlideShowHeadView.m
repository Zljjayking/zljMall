//
//  fxSlideShowHeadView.m
//  Distribution
//
//  Created by hchl on 2018/7/23.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fxSlideShowHeadView.h"
#import <SDCycleScrollView.h>

@interface fxSlideShowHeadView ()<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;


@end
@implementation fxSlideShowHeadView
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 230*KAdaptiveRateWidth) delegate:self placeholderImage:nil FinishBlock:^{
        [MBProgressHUD hideHUD];
    }];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [self addSubview:_cycleScrollView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 230*KAdaptiveRateWidth, kScreenWidth, 85*KAdaptiveRateWidth)];
    view.backgroundColor = myWhite;
    [self addSubview:view];
    self.buttonView = view;
    
    NSArray *imageArr = @[@"pingtuan",@"jingxuan",@"fenlei"];
    NSArray *titleArr = @[@"拼团",@"精选",@"分类"];
    for (int i=0; i<imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        button.frame = CGRectMake(i*(kScreenWidth/3.0), 0, kScreenWidth/3.0, 85*KAdaptiveRateWidth);
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.imageRect = CGRectMake((kScreenWidth/3.0-50*KAdaptiveRateWidth)/2.0, 10*KAdaptiveRateWidth, 50*KAdaptiveRateWidth, 50*KAdaptiveRateWidth);
        button.titleRect = CGRectMake(0, 61*KAdaptiveRateWidth, kScreenWidth/3.0, 14);
        [button setTitleColor:myGrayColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i+1;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setImageGroupArray:(NSArray *)imageGroupArray
{
    _imageGroupArray = imageGroupArray;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner"];
    if (imageGroupArray.count == 0) return;
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;
    
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    if (self.bannerBlock) {
        self.bannerBlock(index);
    }
}
- (void)btnClick:(UIButton *)sender{
    NSInteger index = sender.tag;
    if (self.subButtonBlock) {
        self.subButtonBlock(index);
    }
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
