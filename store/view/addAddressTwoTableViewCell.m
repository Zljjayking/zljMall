//
//  addAddressTwoTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/8.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "addAddressTwoTableViewCell.h"

@implementation addAddressTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputView.delegate = self;
    self.inputView.backgroundColor = clear;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    [self sendSubviewToBack:self.placeHolderLb];
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        self.placeHolderLb.hidden = YES;
    } else {
        self.placeHolderLb.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
