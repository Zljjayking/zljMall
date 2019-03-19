//
//  goodsInfoTwoCollectionCell.m
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsInfoTwoCollectionCell.h"

@implementation goodsInfoTwoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.signLb.font = [UIFont boldSystemFontOfSize:15];
    self.signLb.text = @"拼团玩法(会员可开团)";
}

@end
