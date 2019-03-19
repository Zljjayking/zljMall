//
//  hotGoodsCollectionCell.m
//  Distribution
//
//  Created by hchl on 2018/12/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "hotGoodsCollectionCell.h"

@implementation hotGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    self.bottomBgView.layer.cornerRadius = 5;
    self.bottomBgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.bottomBgView.layer.borderWidth = 0.6;
    
    self.topBgView.layer.cornerRadius = 5;
    self.topBgView.clipsToBounds = YES;
    self.topBgView.backgroundColor = clear;
    if ([account isEqualToString:testNum]) {
        self.shareBtn.hidden = YES;
    }
    self.titleLb.font = [UIFont boldSystemFontOfSize:16];
}
- (void)setGoodsModel:(shoppingCartModel *)goodsModel {
    if ([goodsModel.isGroup isEqualToString:@"1"]) {
        self.groupCountLb.text = [NSString stringWithFormat:@"  %@人拼  ",goodsModel.groupingNum];
        self.groupCountLb.layer.masksToBounds = YES;
        self.groupCountLb.layer.cornerRadius = 8;
        self.groupCountLb.backgroundColor = myRed;
        [self.groupCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBgView.mas_top).offset(22);
            make.left.equalTo(self.bottomBgView.mas_left).offset(8);
            make.height.mas_equalTo(16);
        }];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.groupCountLb.mas_right).offset(8);
            make.centerY.equalTo(self.groupCountLb.mas_centerY);
            make.right.equalTo(self.bottomBgView.mas_right).offset(-8);
            make.height.mas_equalTo(19);
        }];
        self.groupPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.groupingPrice doubleValue]];
        self.originalPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.goodsPrice doubleValue]];
        //groupingGoodsNum
        self.saleCountLb.text = [NSString stringWithFormat:@"已拼：%@件",goodsModel.groupingGoodsNum];
        if ([Utils isBlankString:goodsModel.groupingGoodsNum] || [goodsModel.groupingGoodsNum doubleValue] == 0) {
            self.saleCountLb.text = [NSString stringWithFormat:@"已拼：0件"];
        }
        self.groupCountLb.hidden = NO;
        self.originalPriceLb.hidden = NO;
        self.lineV.hidden = NO;
    }else {
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBgView.mas_left).offset(8);
            make.top.equalTo(self.bottomBgView.mas_top).offset(20);
            make.right.equalTo(self.bottomBgView.mas_right).offset(-8);
            make.height.mas_equalTo(19);
        }];
        self.groupPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.goodsPrice doubleValue]];
        self.saleCountLb.text = [NSString stringWithFormat:@"月销：%@件",goodsModel.num];
        if ([Utils isBlankString:goodsModel.num] || [goodsModel.num doubleValue] == 0) {
            self.saleCountLb.text = [NSString stringWithFormat:@"月销：0件"];
        }
        self.groupCountLb.hidden = YES;
        self.originalPriceLb.hidden = YES;
        self.lineV.hidden = YES;
    }
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
@end
