//
//  goodsDetailHeadCell.m
//  Distribution
//
//  Created by hchl on 2018/12/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsDetailHeadCell.h"

@implementation goodsDetailHeadCell
- (UIImageView *)goodsImage {
    if (!_goodsImage) {
        _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];

    }
    return _goodsImage;
}
- (UIImageView *)signImage {
    if (!_signImage) {
        
        _signImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vipBg_lg"]];
        _signImage.frame = CGRectMake(kScreenWidth-66, naviHeight, 59, 41);
//        UILabel *zheLb = [[UILabel alloc] init];
//        zheLb.text = @"元";
//        zheLb.font = [UIFont systemFontOfSize:13];
//        zheLb.textColor = [UIColor whiteColor];
//        [_signImage addSubview:zheLb];
//
//        [zheLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.signImage.mas_top).offset(13);
//            make.right.equalTo(self.signImage.mas_right).offset(-5);
//            make.height.mas_equalTo(13);
//        }];
//        self.discountLb = [[UILabel alloc]initWithFrame:CGRectMake(23, 5, 27, 25)];
//        self.discountLb.textColor = [UIColor whiteColor];
//
//        self.discountLb.font = [UIFont fontWithName:impactCh size:19];
//        [_signImage addSubview:self.discountLb];
//
//        [self.discountLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.signImage.mas_top).offset(5);
//            make.right.equalTo(zheLb.mas_left).offset(-2);
//            make.height.mas_equalTo(23);
//        }];
//
//        UILabel *vipSign = [[UILabel alloc] init];
//        vipSign.text = @"会员立减";
//        vipSign.font = [UIFont systemFontOfSize:13];
//        vipSign.textColor = [UIColor whiteColor];
//        [_signImage addSubview:vipSign];
//
//        [vipSign mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(zheLb.mas_bottom).offset(1);
//            make.right.equalTo(self.signImage.mas_right).offset(-5);
//            make.height.mas_equalTo(13);
//        }];
    }
    return _signImage;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
    
}
- (void)setupViews {
    [self.contentView addSubview:self.goodsImage];
    [self.contentView addSubview:self.signImage];
}
- (void)setGoodsImageUrl:(NSString *)goodsImageUrl {
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsImageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}
- (void)setDiscount:(NSString *)discount {
//    self.discountLb.text = discount;
}
@end
