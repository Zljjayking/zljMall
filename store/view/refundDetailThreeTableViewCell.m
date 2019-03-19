//
//  refundDetailThreeTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundDetailThreeTableViewCell.h"//高350

@implementation refundDetailThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.oneView.layer.cornerRadius = 3;
    self.twoView.layer.cornerRadius = 3;
    
    self.fillInBtn.layer.masksToBounds = YES;
    self.fillInBtn.layer.borderWidth = 0.7;
    self.fillInBtn.layer.borderColor = myBlueBg.CGColor;
    [self.fillInBtn addTarget:self action:@selector(fillInBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)fillInBtnClick {
    if (self.fillInBtnBlock) {
        self.fillInBtnBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
