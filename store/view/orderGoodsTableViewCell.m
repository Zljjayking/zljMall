//
//  orderGoodsTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "orderGoodsTableViewCell.h"

@implementation orderGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImageV.clipsToBounds = YES;
}
- (void)setModel:(shoppingCartModel *)model {
    self.goodsTitleLb.text = model.goodsName;
    NSString *goodsPreView = [imageHost stringByAppendingString:model.goodsPreview];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:goodsPreView] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.goodsModelLb.text = [NSString stringWithFormat:@"型号参数:无"];
    if (![Utils isBlankString:model.standardProperty]) {
        self.goodsModelLb.text = [NSString stringWithFormat:@"型号参数:%@",model.standardProperty];
    }
    
    self.goodsCountLb.text = [NSString stringWithFormat:@"X%@",model.goodsCount];
    self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.standardPrice doubleValue]];
    if ([model.goodsStandardId isEqualToString:@"0"]) {
        self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.goodsPrice doubleValue]];
        if ([model.isGroup isEqualToString:@"1"]) {
            if ([model.isHead isEqualToString:@"1"]) {
                self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.groupPrice doubleValue]];
            }else {
                self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.groupingPrice doubleValue]];
            }
            
        }
    }
}
- (void)setOrdermodel:(orderModel *)ordermodel {
    self.goodsTitleLb.text = ordermodel.goods_name;
    NSString *goodsPreView = [imageHost stringByAppendingString:ordermodel.goods_preview];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:goodsPreView] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.goodsCountLb.text = [NSString stringWithFormat:@"X%@",ordermodel.sale_num];
    self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[ordermodel.sale_price doubleValue]];
    self.goodsModelLb.text = [NSString stringWithFormat:@"型号参数:无"];
    if (![Utils isBlankString:ordermodel.standard_property]) {
        self.goodsModelLb.text = [NSString stringWithFormat:@"%@:%@",ordermodel.standard_name,ordermodel.standard_property];
    }
    if ([ordermodel.isshelf isEqualToString:@"0"]) {
        self.isShelfLb.backgroundColor = customBackColor;
        self.isShelfLb.hidden = NO;
        self.isShelfLb.text = @"已下架";
    }else {
        self.isShelfLb.hidden = YES;
    }
    
    [self.refundBtn addTarget:self action:@selector(refundBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.logisticsBtn addTarget:self action:@selector(logisticsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //40-退款中 50-退款成功 60-退款失败 70-撤销退款
    switch ([ordermodel.logistics_state integerValue]) {
        case 40:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"退款中";
            self.refundStateLb.textColor = myRed;
        }
            break;
        case 41:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"待退货";
            self.refundStateLb.textColor = myRed;
        }
            break;
        case 42:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"退货中";
            self.refundStateLb.textColor = myRed;
        }
            break;
        case 43:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"待审核";
            self.refundStateLb.textColor = myRed;
        }
            break;
        case 50:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"退款成功";
            self.refundStateLb.textColor = myBlueType;
        }
            break;
        case 60:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"退款失败";
            self.refundStateLb.textColor = [UIColor redColor];
        }
            break;
        case 70:
        {
            self.refundStateLb.hidden = NO;
            self.refundStateLb.text = @"撤销退款";
            self.refundStateLb.textColor = [UIColor grayColor];
        }
            break;
        default:
            self.refundStateLb.hidden = YES;
            break;
    }
    
}
- (void)refundBtnClick {
    if (self.refundBlock) {
        self.refundBlock();
    }
}
- (void)logisticsBtnClick {
    if (self.logisticBlock) {
        self.logisticBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
