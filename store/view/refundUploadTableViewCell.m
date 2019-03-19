//
//  refundUploadTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundUploadTableViewCell.h"

@implementation refundUploadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.backgroundColor = tableViewBgColor;
    [self.oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(20);
        make.left.equalTo(self).offset(13);
        make.width.mas_equalTo(98*KAdaptiveRateWidth);
        make.height.mas_equalTo(99*KAdaptiveRateWidth);
    }];
    
    [self.twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(20);
        make.left.equalTo(self.oneBtn.mas_right).offset((kScreenWidth-26-98*KAdaptiveRateWidth*3)/2.0);
        make.width.mas_equalTo(98*KAdaptiveRateWidth);
        make.height.mas_equalTo(99*KAdaptiveRateWidth);
    }];
    
    [self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(20);
        make.right.equalTo(self).offset(-13);
        make.width.mas_equalTo(98*KAdaptiveRateWidth);
        make.height.mas_equalTo(99*KAdaptiveRateWidth);
    }];
    
    self.oneBtn.tag = 1;
    self.twoBtn.tag = 2;
    self.threeBtn.tag = 3;
    [self.oneBtn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoBtn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBtn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)imageClick:(UIButton *)sender {
    if (self.ImageClickBlock) {
        self.ImageClickBlock(sender.tag);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
