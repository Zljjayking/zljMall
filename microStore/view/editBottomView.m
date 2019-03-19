//
//  editBottomView.m
//  Distribution
//
//  Created by hchl on 2018/12/21.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "editBottomView.h"

@implementation editBottomView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = myWhite;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateSelected];
    [selectAllBtn setImage:[UIImage imageNamed:@"basket_selector"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"basket_selector_on"] forState:UIControlStateSelected];
    selectAllBtn.frame = CGRectMake(10, 5, 70, 40);
    selectAllBtn.imageRect = CGRectMake(0, 10, 20, 20);
    selectAllBtn.titleRect = CGRectMake(26, 10, 44, 20);
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectAllBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:myGrayColor forState:UIControlStateSelected];
    [self addSubview:selectAllBtn];
    self.selectAllBtn = selectAllBtn;
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"roundedRectangle"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"分 享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    shareBtn.frame = CGRectMake(kScreenWidth-85, 10, 70, 30);
    shareBtn.layer.cornerRadius = 15;
    [self addSubview:shareBtn];
    shareBtn.tag = 2;
    self.shareBtn = shareBtn;
    [shareBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBtn setTitle:@"删 除" forState:UIControlStateNormal];
    [removeBtn setTitleColor:myRed forState:UIControlStateNormal];
    [self addSubview:removeBtn];
    removeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    removeBtn.layer.masksToBounds = YES;
    removeBtn.layer.cornerRadius = 15;
    removeBtn.frame = CGRectMake(kScreenWidth-85-70-15, 10, 70, 30);
    removeBtn.layer.borderColor = myRed.CGColor;
    removeBtn.layer.borderWidth = 0.7;
    removeBtn.tag = 1;
    self.removeBtn = removeBtn;
    [removeBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)selectAllBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectAllBlock) {
        self.selectAllBlock(sender.selected);
    }
}
- (void)editBtnClick:(UIButton *)sender {
    if (self.editBlock) {
        self.editBlock(sender.tag);
    }
}
@end
