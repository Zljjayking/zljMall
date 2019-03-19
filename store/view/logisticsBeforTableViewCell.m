//
//  logisticsBeforTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "logisticsBeforTableViewCell.h"

@implementation logisticsBeforTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
