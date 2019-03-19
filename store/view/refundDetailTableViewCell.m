//
//  refundDetailTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundDetailTableViewCell.h"//高90

@implementation refundDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = myBlueBg;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLb.font = [UIFont boldSystemFontOfSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
