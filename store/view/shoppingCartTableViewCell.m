//
//  shoppingCartTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/7/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "shoppingCartTableViewCell.h"

@implementation shoppingCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 5;
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
    
    [self.goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right);
        make.centerY.equalTo(self.bgView);
//        make.top.equalTo(self.bgView.mas_top).offset(10);
//        make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    [self.goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.mas_right).offset(10);
        make.top.equalTo(self.goodsImage);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    [self.goodsModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.mas_right).offset(10);
        make.top.equalTo(self.goodsInfoLabel.mas_bottom).offset(9);
        make.height.mas_equalTo(14);
    }];
    [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.mas_right).offset(10);
        make.bottom.equalTo(self.goodsImage.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.addBtn];
    [self addSubview:self.goodsCountLabel];
    [self addSubview:self.subsractBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-9);
        make.bottom.equalTo(self.bgView).offset(-8);
        make.width.mas_equalTo(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
    [self.goodsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addBtn.mas_left).offset(-8);
        make.centerY.equalTo(self.addBtn);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
    [self.subsractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsCountLabel.mas_left).offset(-8);
        make.centerY.equalTo(self.addBtn);
        make.width.mas_equalTo(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.subsractBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.isNotWorkLb.layer.masksToBounds = YES;
    self.isNotWorkLb.layer.cornerRadius = 9.5;
    self.isNotWorkLb.backgroundColor = customBackColor;
    self.isNotWorkLb.hidden = YES;
}
- (void)setModel:(shoppingCartModel *)model {
    _model = model;
    CGFloat height = [FXSpeedy fx_calculateTextSizeWithText:model.goodsName WithTextFont:[UIFont systemFontOfSize:14] WithMaxW:(kScreenWidth - 178)].height;
    self.goodsInfoLabel.numberOfLines = 1;
    if (height > 28) {
        height = 35;
        self.goodsInfoLabel.numberOfLines = 2;
    }
    self.goodsInfoLabel.text = model.goodsName;
    if ([Utils isBlankString:model.standardName]) {
        model.standardName = @"型号规格";
    }
    self.goodsModelLabel.text = [NSString stringWithFormat:@"%@：%@",model.standardName,model.standardProperty];
    if ([model.goodsStandardId isEqualToString:@"0"] || [Utils isBlankString:model.goodsStandardId]) {
        self.goodsModelLabel.text = @"型号规格：无";
    }
    
    self.selectBtn.selected = model.isSelect;
    if (!model.isSelect) {
        self.selectImage.image = [UIImage imageNamed:@"basket_selector"];
    } else {
        self.selectImage.image = [UIImage imageNamed:@"basket_selector_on"];
    }
    
    [self.goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage);
        make.left.equalTo(self.goodsImage.mas_right).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.mas_equalTo(height);
    }];
    self.goodsCountLabel.text = model.goodsCount;
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.standardPrice doubleValue]];
    if ([model.goodsStandardId isEqualToString:@"0"]) {
        self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.goodsPrice doubleValue]];
    }
    NSString *goodsPreView = [imageHost stringByAppendingString:model.goodsPreview];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsPreView] placeholderImage:[UIImage imageNamed:@"goods"]];
    
    if ([model.isshelf isEqualToString:@"0"]) {
        if ([model.isDelete isEqualToString:@"0"]) {
            self.selectBtn.hidden = YES;
            self.selectImage.hidden = YES;
            self.goodsCountLabel.hidden = YES;
            self.addBtn.hidden = YES;
            self.subsractBtn.hidden = YES;
            self.isNotWorkLb.hidden = NO;
        } else {
            self.goodsCountLabel.hidden = YES;
            self.addBtn.hidden = YES;
            self.subsractBtn.hidden = YES;
            self.selectBtn.hidden = NO;
            self.selectImage.hidden = NO;
            self.isNotWorkLb.hidden = YES;
        }
    }else {
        self.goodsCountLabel.hidden = NO;
        self.addBtn.hidden = NO;
        self.subsractBtn.hidden = NO;
        self.selectBtn.hidden = NO;
        self.selectImage.hidden = NO;
        self.isNotWorkLb.hidden = YES;
    }
    
}
//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
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
