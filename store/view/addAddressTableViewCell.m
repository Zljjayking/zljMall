//
//  addAddressTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/8.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "addAddressTableViewCell.h"

@implementation addAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.inputView setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.inputView.width = 330*KAdaptiveRateWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
