//
//  goodsInfoOverFooterView.m
//  Distribution
//
//  Created by hchl on 2018/7/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsInfoOverFooterView.h"

@interface goodsInfoOverFooterView ()
/* 底部上拉提示 */
@property (strong , nonatomic) UIButton *overMarkButton;

@end

@implementation goodsInfoOverFooterView
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
//- (void)setUpUI
//{
//    self.backgroundColor = FXBGColor;
//    _overMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_overMarkButton setImage:[UIImage imageNamed:@"Details_Btn_Up"] forState:UIControlStateNormal];//Details_Btn_Up
//    [_overMarkButton setTitle:@"下拉查看图文详情" forState:UIControlStateNormal];
//    _overMarkButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [_overMarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self addSubview:_overMarkButton];
//
//    _overMarkButton.frame = CGRectMake(0, 0, self.width, self.height);
//}
- (void)setUpUI
{
    self.backgroundColor = FXBGColor;
    _overMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_overMarkButton setImage:[UIImage imageNamed:@"placeHolder"] forState:UIControlStateNormal];//Details_Btn_Up
    [_overMarkButton setTitle:@"---图文详情---" forState:UIControlStateNormal];
    _overMarkButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_overMarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_overMarkButton];
    
    _overMarkButton.frame = CGRectMake(0, 0, self.width, 30);
    
}
@end
