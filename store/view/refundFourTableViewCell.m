//
//  refundFourTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundFourTableViewCell.h"//高270

@implementation refundFourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.oneView.layer.cornerRadius = 3;
    
    self.cancelApplyBtn.layer.masksToBounds = YES;
    self.cancelApplyBtn.layer.borderWidth = 0.7;
    self.cancelApplyBtn.layer.borderColor = myGrayColor.CGColor;
    [self.cancelApplyBtn addTarget:self action:@selector(cancelApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancelApplyBtnClick {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
