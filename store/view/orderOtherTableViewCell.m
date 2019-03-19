//
//  orderOtherTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "orderOtherTableViewCell.h"

@implementation orderOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
