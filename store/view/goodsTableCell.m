//
//  goodsTableCell.m
//  Distribution
//
//  Created by hchl on 2018/12/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsTableCell.h"

@implementation goodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomBgView.layer.cornerRadius = 5;
    self.bottomBgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.bottomBgView.layer.borderWidth = 0.6;
    
    self.topBgView.layer.cornerRadius = 5;
    self.topBgView.clipsToBounds = YES;
    self.topBgView.backgroundColor = clear;
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        self.shareBtn.hidden = YES;
    }
    self.titleLb.font = [UIFont boldSystemFontOfSize:16];
}
- (void)setGoodsModel:(shoppingCartModel *)goodsModel {
    CGFloat width = 0.0;
    NSString *countStr;
    if ([goodsModel.isGroup isEqualToString:@"1"]) {
//        self.groupCountLb.hidden = NO;
        countStr = [NSString stringWithFormat:@"  %@人拼  ",goodsModel.groupingNum];
        width = [countStr widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:16];
        
        self.groupPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.groupingPrice doubleValue]];
        self.originalPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.goodsPrice doubleValue]];
        //groupingGoodsNum
        self.saleCountLb.text = [NSString stringWithFormat:@"已拼：%@件",goodsModel.groupingGoodsNum];
        if ([Utils isBlankString:goodsModel.groupingGoodsNum] || [goodsModel.groupingGoodsNum doubleValue] == 0) {
            self.saleCountLb.text = [NSString stringWithFormat:@"已拼：0件"];
        }
        
        self.originalPriceLb.hidden = NO;
        self.lineV.hidden = NO;
    }else {

        self.groupPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.goodsPrice doubleValue]];
        self.originalPriceLb.text = @" ";
        self.saleCountLb.text = [NSString stringWithFormat:@"月销：%@件",goodsModel.num];
        if ([Utils isBlankString:goodsModel.num] || [goodsModel.num doubleValue] == 0) {
            self.saleCountLb.text = [NSString stringWithFormat:@"月销：0件"];
        }
        self.originalPriceLb.hidden = NO;
        self.lineV.hidden = YES;
    }
    
    self.groupCountLb.text = countStr;
    self.groupCountLb.layer.masksToBounds = YES;
    self.groupCountLb.layer.cornerRadius = 8;
    self.groupCountLb.backgroundColor = myRed;
    
    [self.groupCountLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomBgView.mas_top).offset(22);
        make.left.equalTo(self.bottomBgView.mas_left).offset(8);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(16);
    }];
    [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBgView.mas_left).offset(8+(width>0?width+8:0));
        make.centerY.equalTo(self.groupCountLb.mas_centerY);
        make.right.equalTo(self.bottomBgView.mas_right).offset(-8);
        make.height.mas_equalTo(19);
    }];
    
    NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,goodsModel.goodsPreview];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:goodsImage] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.titleLb.text = goodsModel.goodsName;
    if ([Utils isBlankString:goodsModel.vipRebatePrice]) {
        self.vipBgImage.hidden = YES;
        
    }else {
        self.vipBgImage.hidden = NO;
        
        if ([goodsModel.vipRebatePrice doubleValue] == 0) {
            self.vipBgImage.hidden = YES;
            
        }
    }
    
}
- (void)shareBtnClick {
    if (self.shareBlock) {
        self.shareBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
