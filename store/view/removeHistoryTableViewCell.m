//
//  removeHistoryTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "removeHistoryTableViewCell.h"

@implementation removeHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.removeHistoryBtn.layer.masksToBounds = YES;
    self.removeHistoryBtn.layer.cornerRadius = 15;
    self.removeHistoryBtn.layer.borderColor = RGB(102, 102, 102).CGColor;
    self.removeHistoryBtn.layer.borderWidth = 0.5;
    [self.removeHistoryBtn addTarget:self action:@selector(removeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}
- (void)removeBtnClick {
    if (self.block) {
        self.block();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
