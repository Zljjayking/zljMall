//
//  goodsInfoCollectionCell.m
//  Distribution
//
//  Created by hchl on 2018/12/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsInfoCollectionCell.h"

@implementation goodsInfoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shareGoodsBtn addTarget:self action:@selector(shareGoodsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        self.shareGoodsBtn.hidden = YES;
    }
    self.groupPriceLb.font = [UIFont boldSystemFontOfSize:20];
    self.goodsDetailsLb.font = [UIFont boldSystemFontOfSize:15];
    UILabel *groupNumLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 0, 16)];
    groupNumLb.layer.masksToBounds = YES;
    groupNumLb.layer.cornerRadius = 8;
    groupNumLb.font = [UIFont systemFontOfSize:13];
    groupNumLb.textColor = myWhite;
    groupNumLb.backgroundColor = myRed;
    [self.goodsDetailsLb addSubview:groupNumLb];
    self.groupNumLb = groupNumLb;
    self.salesVolumeLb.hidden = YES;
}
- (void)setGoodsModel:(shoppingCartModel *)goodsModel {
    
    NSString *groupNum = [NSString stringWithFormat:@"  %@人拼  ",goodsModel.groupingNum];
    CGFloat width = [groupNum widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:15];
    self.groupNumLb.text = groupNum;
    self.groupNumLb.frame = CGRectMake(0, 1, width, 16);
    
    [FXSpeedy fx_setUpLabel:self.goodsDetailsLb Content:goodsModel.goodsName IndentationFortheFirstLineWith:width+7 font:[UIFont boldSystemFontOfSize:15]];
    
    self.groupPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.groupingPrice doubleValue]];
    
    self.originalPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.goodsPrice doubleValue]];
    
    self.expressageLb.text = [NSString stringWithFormat:@"快递费:¥%.2f",[goodsModel.fare doubleValue]];
    if ([Utils isBlankString:goodsModel.fare] || [goodsModel.fare doubleValue] == 0) {
        self.expressageLb.text = @"快递费:免运费";
    }
    self.spellNumLb.text = [NSString stringWithFormat:@"已拼%@件",goodsModel.groupingGoodsNum];
    self.salesVolumeLb.text = [NSString stringWithFormat:@"月销:%@件",[Utils isBlankString:goodsModel.num]?@"0":goodsModel.num];
    
}
- (void)shareGoodsBtnClick {
    if (self.shareBlock) {
        self.shareBlock();
    }
}
@end
