//
//  hotGoodsCollectionViewCell.m
//  Distribution
//
//  Created by hchl on 2018/7/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "hotGoodsCollectionViewCell.h"

@implementation hotGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImage.clipsToBounds = YES;
    [self bringSubviewToFront:self.priceLabel];
    [self bringSubviewToFront:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    
    if ([account isEqualToString:testNum]) {
        self.shareBtn.hidden = YES;
    }
}
- (void)shareBtnClick {
    if (self.shareBlock) {
        self.shareBlock();
    }
}
@end
