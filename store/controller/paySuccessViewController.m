//
//  paySuccessViewController.m
//  Distribution
//
//  Created by hchl on 2018/8/10.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "paySuccessViewController.h"

@interface paySuccessViewController ()

@end

@implementation paySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.selfTitle;
    [self setupView];
    [self.view addSubview:self.naviBarView];
    // Do any additional setup after loading the view.
}
- (void)setupView {
    self.view.backgroundColor = myWhite;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageTitle]];
    image.frame = CGRectMake(0, 0, 80, 80);
    image.center = CGPointMake(kScreenWidth/2.0, kScreenWidth/2.0+40);
    [self.view addSubview:image];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = self.operation;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:20];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(25);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *subTitleOne = [[UILabel alloc] init];
    [self.view addSubview:subTitleOne];
    subTitleOne.text = self.subTitleOne;
    subTitleOne.textAlignment = NSTextAlignmentCenter;
    subTitleOne.font = [UIFont systemFontOfSize:13];
    subTitleOne.textColor = RGB(100, 100, 100);
    [subTitleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(30);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *subTitleTwo = [[UILabel alloc] init];
    [self.view addSubview:subTitleTwo];
    subTitleTwo.text = self.subTitleTwo;
    subTitleTwo.textAlignment = NSTextAlignmentCenter;
    subTitleTwo.font = [UIFont systemFontOfSize:13];
    subTitleTwo.textColor = RGB(100, 100, 100);
    [subTitleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleOne.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:leftBtn];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = 17;
    leftBtn.layer.borderWidth = 0.5;
    leftBtn.layer.borderColor = myBlueBg.CGColor;
    [leftBtn setTitle:self.leftBtnTitle forState:UIControlStateNormal];
    [leftBtn setTitleColor:myBlueType forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleTwo.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(kScreenWidth/2.0-125*KAdaptiveRateWidth);
        make.width.mas_equalTo(110*KAdaptiveRateWidth);
        make.height.mas_equalTo(34);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rightBtn];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = 17;
    rightBtn.layer.borderWidth = 0.5;
    rightBtn.layer.borderColor = myBlueBg.CGColor;
    [rightBtn setTitle:self.rightBtnTitle forState:UIControlStateNormal];
    [rightBtn setTitleColor:myBlueType forState:UIControlStateNormal];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleTwo.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(kScreenWidth/2.0+15*KAdaptiveRateWidth);
        make.width.mas_equalTo(110*KAdaptiveRateWidth);
        make.height.mas_equalTo(34);
    }];
    
    
}

- (void)leftBtnClick {
    if (self.btnBlock) {
        self.btnBlock(1);
    }
}
- (void)rightBtnClick {
    if (self.btnBlock) {
        self.btnBlock(2);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
