//
//  grouperHeaderCollectionCell.m
//  Distribution
//
//  Created by hchl on 2018/12/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "grouperHeaderCollectionCell.h"

@implementation grouperHeaderCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setGroupModel:(groupingModel *)groupModel {
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingString:groupModel.portrait]] placeholderImage:[UIImage imageNamed:@"user_info_default"]];
    if ([groupModel.isHead isEqualToString:@"1"]) {
        self.signImage.image = [UIImage imageNamed:@"icon_crown"];
    }
}
@end
