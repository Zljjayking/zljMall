//
//  goodsPopCountTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsPopCountTableViewCell.h"

@implementation goodsPopCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGBA(245, 246, 248,1);
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, kScreenWidth-10, 17)];
    titleLabel.text = @"购买数量";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    self.titleLabel = titleLabel;
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    [addBtn setImage:ZLJBundleImageNamed(@"cart_addBtn_highlight") forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.numberLabel];
    self.numberLabel.backgroundColor = RGB(235, 235, 235);
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left).offset(-5);
        make.centerY.equalTo(addBtn);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(20);
    }];
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:@"subtract"] forState:UIControlStateNormal];
//    [cutBtn setImage:ZLJBundleImageNamed(@"cart_cutBtn_highlight") forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cutBtn];
    [cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberLabel.mas_left).offset(-5);
        make.height.equalTo(addBtn);
        make.width.equalTo(addBtn);
        make.bottom.equalTo(addBtn);
    }];
}
// 数量加按钮
-(void)addBtnClick
{
    if (self.numAddBlock) {
        self.numAddBlock();
    }
}

//数量减按钮
-(void)cutBtnClick
{
    if (self.numCutBlock) {
        self.numCutBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
