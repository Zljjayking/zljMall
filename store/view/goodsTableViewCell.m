//
//  goodsTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsTableViewCell.h"

@implementation goodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    self.backgroundColor = FXBGColor;
    self.goodsImageV.layer.masksToBounds = YES;
    self.goodsImageV.layer.cornerRadius = 5;
    [self.sharebtn addTarget:self action:@selector(shareGoods) forControlEvents:UIControlEventTouchUpInside];
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        self.sharebtn.hidden = YES;
    }
    
}
- (void)shareGoods {
    if (self.shareBlock) {
        self.shareBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setGoodsModel:(shoppingCartModel *)goodsModel {
    NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,goodsModel.goodsPreview];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:goodsImage] placeholderImage:[UIImage imageNamed:@"goods"]];
    
    self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.goodsPrice doubleValue]];
    
    if ([Utils isBlankString:goodsModel.vipRebatePrice]) {
        self.vipBgImage.hidden = YES;
        
    }else {
        self.vipBgImage.hidden = NO;
        
        if ([goodsModel.vipRebatePrice doubleValue] == 0) {
            self.vipBgImage.hidden = YES;
            
        }
    }
}
@end
