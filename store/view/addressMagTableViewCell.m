//
//  addressMagTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/6.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "addressMagTableViewCell.h"

@implementation addressMagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = RGB(241, 243, 246);
    [self.defaultBtn setImage:[UIImage imageNamed:@"basket_selector"] forState:UIControlStateNormal];
    [self.defaultBtn setImage:[UIImage imageNamed:@"address_selector"] forState:UIControlStateSelected];
    [self.defaultBtn addTarget:self action:@selector(setDefault:) forControlEvents:UIControlEventTouchUpInside];
    self.defaultBtn.titleRect = CGRectMake(25, 0, 60, 25);
    self.defaultBtn.imageRect = CGRectMake(0, 3, 19, 19);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.editBtn.imageRect = CGRectMake(0, 5, 15, 15);
    self.editBtn.titleRect = CGRectMake(25, 0, 30, 25);
    [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setModel:(addressModel *)model {
    self.nameLb.text = model.receivePerson;
    if (model.receivePhone.length == 11) {
        self.mobileLb.text = [model.receivePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else {
        self.mobileLb.text = model.receivePhone;
    }
    
    self.addressLb.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.pro,model.city,model.area,model.des];
    self.defaultBtn.selected = [model.def boolValue];
    self.defaultBtn.hidden = ![model.def boolValue];
}
- (void)setDefault:(UIButton *)sender {
    sender.selected = YES;
    if (self.defaultBlcok) {
        self.defaultBlcok(sender.selected);
    }
}
- (void)editBtnClick {
    if (self.editBlock) {
        self.editBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
