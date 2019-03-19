//
//  refundInstructionTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundInstructionTableViewCell.h"

@implementation refundInstructionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentTv.delegate = self;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        self.placeHolderLb.hidden = YES;
    }else {
        self.placeHolderLb.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
