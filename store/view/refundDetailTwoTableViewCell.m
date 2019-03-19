//
//  refundDetailTwoTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundDetailTwoTableViewCell.h"//高180

@implementation refundDetailTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.OnePointView.layer.cornerRadius = 3;
    self.twoPointView.layer.cornerRadius = 3;
    
    self.modifyBtn.layer.masksToBounds = YES;
    self.modifyBtn.layer.borderWidth = 0.7;
    self.modifyBtn.layer.borderColor = myBlueBg.CGColor;
    
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderWidth = 0.7;
    self.cancelBtn.layer.borderColor = RGB(70, 70, 70).CGColor;
    
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.modifyBtn addTarget:self action:@selector(modifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancelBtnClick {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (void)modifyBtnClick {
    if (self.modifyBlock) {
        self.modifyBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
