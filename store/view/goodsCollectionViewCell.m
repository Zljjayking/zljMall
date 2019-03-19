//
//  goodsCollectionViewCell.m
//  Distribution
//
//  Created by hchl on 2018/7/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsCollectionViewCell.h"

@implementation goodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImage.clipsToBounds = YES;
    
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    self.vipBgImage.hidden = YES;
    
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
