//
//  goodsPopHeadTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsPopHeadTableViewCell.h"

@implementation goodsPopHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 5;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.signLb.textColor = myRed;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
