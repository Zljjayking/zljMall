//
//  orderDetailFootTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "orderDetailFootTableViewCell.h"

@implementation orderDetailFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fuzhiBtn.layer.masksToBounds = YES;
    self.fuzhiBtn.layer.cornerRadius = 9;
    self.fuzhiBtn.layer.borderColor = RGB(102, 102, 102).CGColor;
    self.fuzhiBtn.layer.borderWidth = 0.5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.fuzhiBtn addTarget:self action:@selector(fuzhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)fuzhiBtnClick {
    if (self.fuzhiBlock) {
        self.fuzhiBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
