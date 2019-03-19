//
//  goodsPopSpecificationTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsPopSpecificationTableViewCell.h"

@implementation goodsPopSpecificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, kScreenWidth-10, 17)];
    titleLabel.text = @"请选择型号样式";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
}
- (void)setButtonArray:(NSArray *)buttonArray {
    _buttonArray = buttonArray;
    if (_buttonArray.count) {
        float butX = 15;
        float butY = CGRectGetMaxY(self.titleLabel.frame)+15;
        for(int i = 0; i < _buttonArray.count; i++){
            GoodsCategoryModel *model = _buttonArray[i];
            NSString *sizeStr = model.title;
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGRect frame_W = [sizeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (butX+frame_W.size.width+20>kScreenWidth-15) {
                
                butX = 15;
                
                butY += 40;
            }
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 28)];
            [but setTitle:sizeStr forState:UIControlStateNormal];
            but.tag = i+1;
            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [but setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
            [but setBackgroundImage:[UIImage imageWithColor:FXBGColor] forState:UIControlStateNormal];
            [but setBackgroundImage:[UIImage imageWithColor:RGBA(207, 23, 49, 1)] forState:UIControlStateSelected];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            but.layer.masksToBounds = YES;
            but.layer.cornerRadius = 14;
            if ([_selectID isEqualToString:model.no]) {
                but.selected = YES;
            }
            [self addSubview:but];
            butX = CGRectGetMaxX(but.frame)+10;
        }
    }else {
        self.titleLabel.hidden = YES;
    }
}
- (void)setSelectID:(NSString *)selectID {
    _selectID = selectID;
}
- (void)butClick:(UIButton *)sender {
    for (int i = 0; i < 17; i++) {
        UIButton *but = [self viewWithTag:i+1];
        if (sender.tag == but.tag) {
            sender.selected = !sender.selected;
            GoodsCategoryModel *model = _buttonArray[sender.tag-1];
            if (sender.selected) {
                if (self.specificationBlock != nil) {
                    self.specificationBlock(model);
                }
            } else {
                if (self.specificationBlock != nil) {
                    self.specificationBlock(nil);
                }
            }
        } else {
            but.selected = NO;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
