//
//  orderSiteTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "orderSiteTableViewCell.h"

@implementation orderSiteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (@available(iOS 8.2, *)) {
        self.nameLb.font = [UIFont systemFontOfSize:16 weight:1];
//        self.mobileLb.font = [UIFont systemFontOfSize:16 weight:1];
    } else {
        self.nameLb.font = [UIFont boldSystemFontOfSize:16];
//        self.mobileLb.font = [UIFont boldSystemFontOfSize:16];
    }
    self.defaultLb.layer.borderColor = RGB(37, 128, 253).CGColor;
    self.defaultLb.layer.borderWidth = 0.5;
    [self.seperatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(5);
    }];
    self.backgroundColor = myWhite;
    // Initialization code
}
- (void)setAddress:(addressModel *)address {
    if (address) {
        self.nameLb.text = address.receivePerson;
        if (address.receivePhone.length == 11) {
            self.mobileLb.text = [address.receivePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else {
            self.mobileLb.text = address.receivePhone;
        }
        
        self.placeLb.text = [NSString stringWithFormat:@"%@%@%@%@",address.pro,address.city,address.area,address.des];
        
    } else {
        self.nameLb.text = @"请选择收货地址";
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
