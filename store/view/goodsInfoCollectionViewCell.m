//
//  goodsInfoCollectionViewCell.m
//  Distribution
//
//  Created by hchl on 2018/7/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsInfoCollectionViewCell.h"

@implementation goodsInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shareGoodsBtn addTarget:self action:@selector(shareGoodsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        self.shareGoodsBtn.hidden = YES;
    }
    self.goodsDetailsLb.font = [UIFont boldSystemFontOfSize:15];
    self.vipRebateLb.layer.masksToBounds = YES;
    self.vipRebateLb.layer.cornerRadius = 4;
    self.vipRebateLb.layer.borderWidth = 0.6;
    self.vipRebateLb.layer.borderColor = RGB(213, 38, 33).CGColor;
    
    self.vipRebateLb.hidden = YES;
}
- (void)shareGoodsBtnClick {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
