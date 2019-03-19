//
//  refundMoneyTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundMoneyTableViewCell.h"

@implementation refundMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.backgroundColor = tableViewBgColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.unitLb.textColor = myRed;
    self.contentTf.textColor = myRed;
    self.contentTf.text = @"197.00";
//    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    self.contentTf.attributedPlaceholder = [NSAttributedString.alloc initWithString:@"197.00" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
