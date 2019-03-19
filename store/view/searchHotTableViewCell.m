//
//  searchHotTableViewCell.m
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "searchHotTableViewCell.h"

@implementation searchHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}
- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, kScreenWidth-10, 17)];
    titleLabel.text = @"热搜";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
}
- (void)setButtonArray:(NSArray *)buttonArray {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setupView];
    _buttonArray = buttonArray;
    if (_buttonArray.count) {
        float butX = 15;
        float butY = CGRectGetMaxY(self.titleLabel.frame)+13;
        for(int i = 0; i < _buttonArray.count; i++){
            NSString *sizeStr = _buttonArray[i];
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGRect frame_W = [sizeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (butX+frame_W.size.width+20>kScreenWidth-15) {
                
                butX = 15;
                
                butY += 35;
            }
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 23)];
            [but setTitle:sizeStr forState:UIControlStateNormal];
            but.tag = i+1;
            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [but setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
            [but setBackgroundImage:[UIImage imageWithColor:FXBGColor] forState:UIControlStateNormal];
//            [but setBackgroundImage:[UIImage imageWithColor:RGBA(207, 23, 49, 1)] forState:UIControlStateSelected];
            but.titleLabel.font = [UIFont systemFontOfSize:12];
            but.layer.masksToBounds = YES;
            but.layer.cornerRadius = 11.5;
            //            but.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //            but.layer.borderWidth = 1;
            [self addSubview:but];
            butX = CGRectGetMaxX(but.frame)+10;
        }
    }
}
- (void)butClick:(UIButton *)sender {
    for (int i = 0; i < 17; i++) {
        UIButton *but = [self viewWithTag:i+1];
        if (sender.tag == but.tag) {
//            sender.selected = !sender.selected;
            NSString *hotStr = _buttonArray[sender.tag-1];
            if (self.hotBlock != nil) {
                self.hotBlock(hotStr);
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
