//
//  refundInfoTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundInfoTableViewCell.h"//高270

@implementation refundInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsView.backgroundColor = tableViewBgColor;
    self.goodsImage.clipsToBounds = YES;
}
- (void)setModel:(orderModel *)model {
    self.goodsTitleLb.text = model.goods_name;
    NSString *goodsPreView = [imageHost stringByAppendingString:model.goods_preview];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsPreView] placeholderImage:[UIImage imageNamed:@"goods"]];
//    self.goodsCountLb.text = [NSString stringWithFormat:@"X%@",model.sale_num];
//    self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.sale_price doubleValue]];
    self.goodsModelLb.text = [NSString stringWithFormat:@"型号参数:无"];
    if (![Utils isBlankString:model.standard_property]) {
        self.goodsModelLb.text = [NSString stringWithFormat:@"%@:%@",model.standard_name,model.standard_property];
    }
    if ([model.isshelf isEqualToString:@"0"]) {
        self.isshelfLb.backgroundColor = customBackColor;
        self.isshelfLb.hidden = NO;
        self.isshelfLb.text = @"已下架";
    }else {
        self.isshelfLb.hidden = YES;
    }
    
    self.refundReasonLb.text = [NSString stringWithFormat:@"退款原因：%@",model.refundCause];
    self.refundMoneyLb.text = [NSString stringWithFormat:@"退款金额：¥%.2f",[model.returnMoney doubleValue]];
    NSString *time = [NSString isoTimeToStringWithDateString:model.applyTime];
    self.applyTimeLb.text = [NSString stringWithFormat:@"申请时间：%@",time];
    self.applyCountLb.text = [NSString stringWithFormat:@"申请件数：%@",model.sale_num];
    self.refundNumLb.text = [NSString stringWithFormat:@"退款编号：%@",model.refundNumber];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
