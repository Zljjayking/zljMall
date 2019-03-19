//
//  searchHeaderView.m
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "searchHeaderView.h"

@implementation searchHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = myWhite;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    CGFloat leftAndRightMargin = 33*KAdaptiveRateWidth;
    CGFloat btnW = 45;
    CGFloat btnH = 35;
    CGFloat seperator = (kScreenWidth - leftAndRightMargin*2 - btnW*4)/3.0;
    self.index = 0;
    self.isAscending = 1;
    self.synthesizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.synthesizeBtn.tag = 1;
    self.synthesizeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.synthesizeBtn.frame = CGRectMake(leftAndRightMargin, 3, btnW, btnH);
    [self.synthesizeBtn setTitle:@"综合" forState:UIControlStateNormal];
    [self.synthesizeBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
    [self.synthesizeBtn setTitleColor:myBlueType forState:UIControlStateSelected];
    self.synthesizeBtn.selected = YES;
    [self addSubview:self.synthesizeBtn];
    [self.synthesizeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.volumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.volumeBtn.tag = 2;
    self.volumeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.volumeBtn.frame = CGRectMake(leftAndRightMargin+btnW+seperator, 3, btnW, btnH);
    [self.volumeBtn setTitle:@"销量" forState:UIControlStateNormal];
    [self.volumeBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
    [self.volumeBtn setTitleColor:myBlueType forState:UIControlStateSelected];
    [self addSubview:self.volumeBtn];
    [self.volumeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceBtn.tag = 3;
    self.priceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.priceBtn.frame = CGRectMake(leftAndRightMargin+btnW*2+seperator*2, 3, btnW, btnH);
    [self.priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:myBlueType forState:UIControlStateSelected];
    [self addSubview:self.priceBtn];
    [self.priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *sortView = [[UIView alloc] initWithFrame:CGRectMake(leftAndRightMargin+btnW*3+seperator*2-2, 14, 10, 13)];
    [self addSubview:sortView];
    self.priceImageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ascending"]];
    self.priceImageOne.frame = CGRectMake(0, 0, 10, 10);
    [sortView addSubview:self.priceImageOne];
    self.priceImageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"descending"]];
    self.priceImageTwo.frame = CGRectMake(0, 3, 10, 10);
    [sortView addSubview:self.priceImageTwo];
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.returnBtn.tag = 4;
    self.returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.returnBtn.frame = CGRectMake(leftAndRightMargin+btnW*3+seperator*3, 3, btnW, btnH);
    [self.returnBtn setTitle:@"返佣" forState:UIControlStateNormal];
    [self.returnBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
    [self.returnBtn setTitleColor:myBlueType forState:UIControlStateSelected];
    [self addSubview:self.returnBtn];
    [self.returnBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *sortViewTwo = [[UIView alloc] initWithFrame:CGRectMake(leftAndRightMargin+btnW*4+seperator*3-2, 14, 10, 13)];
    [self addSubview:sortViewTwo];
//    self.returnImageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ascending"]];
    self.returnImageOne.frame = CGRectMake(0, 0, 10, 10);
    [sortViewTwo addSubview:self.returnImageOne];
//    self.returnImageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"descending"]];
    self.returnImageTwo.frame = CGRectMake(0, 3, 10, 10);
    [sortViewTwo addSubview:self.returnImageTwo];
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(leftAndRightMargin+2.5, btnH+1, btnW-5, 2)];
    bgV.backgroundColor = myBlueType;
    [self addSubview:bgV];
    self.lineV = bgV;
}
- (void)btnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.lineV.frame = CGRectMake(sender.x+2.5, 36, 40, 2);
    }];
    if (sender.tag == 3) {
        if (self.index != 2) {
            self.priceImageOne.image = [UIImage imageNamed:@"ascending_select"];
            self.isAscending = YES;
        } else {
            if (self.isAscending) {
                self.priceImageOne.image = [UIImage imageNamed:@"ascending"];
                self.priceImageTwo.image = [UIImage imageNamed:@"descending_select"];
                self.isAscending = NO;
            } else {
                self.priceImageOne.image = [UIImage imageNamed:@"ascending_select"];
                self.priceImageTwo.image = [UIImage imageNamed:@"descending"];
                self.isAscending = YES;
            }
            
        }
    } else {
        self.priceImageOne.image = [UIImage imageNamed:@"ascending"];
        self.priceImageTwo.image = [UIImage imageNamed:@"descending"];
    }
    
    if (sender.tag == 4) {
        if (self.index != 3) {
            [sender setTitle:@"返佣" forState:UIControlStateSelected];
            self.isAscending = YES;
        } else {
            if (self.isAscending) {
//                self.returnImageOne.image = [UIImage imageNamed:@"ascending"];
//                self.returnImageTwo.image = [UIImage imageNamed:@"descending_select"];
                [sender setTitle:@"返佣" forState:UIControlStateSelected];
                self.isAscending = YES;
            } else {
//                self.returnImageOne.image = [UIImage imageNamed:@"ascending_select"];
//                self.returnImageTwo.image = [UIImage imageNamed:@"descending"];
                [sender setTitle:@"有返佣" forState:UIControlStateSelected];
                self.isAscending = YES;
            }
            
        }
    } else {
//        self.returnImageOne.image = [UIImage imageNamed:@"ascending"];
//        self.returnImageTwo.image = [UIImage imageNamed:@"descending"];
//        [sender setTitle:@"返佣" forState:UIControlStateNormal];
    }
    
    
    for (int i=0; i<4; i++) {
        UIButton *btn = [self viewWithTag:i+1];
        btn.selected = NO;
    }
    sender.selected = !sender.selected;
    self.index = sender.tag-1;
    if (self.block) {
        self.block(self.index,self.isAscending);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
