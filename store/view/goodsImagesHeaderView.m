//
//  goodsImagesHeaderView.m
//  Distribution
//
//  Created by hchl on 2018/7/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsImagesHeaderView.h"
#import <SDCycleScrollView.h>
#import "goodsDetailHeadCell.h"
@interface goodsImagesHeaderView()<SDCycleScrollViewDelegate>
/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIImageView *vipBgImage;
@property (nonatomic, strong) UILabel *discountLb;
@end

@implementation goodsImagesHeaderView
- (UIImageView *)vipBgImage {
    if (!_vipBgImage) {
        
        _vipBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vipBg_lg"]];
        _vipBgImage.frame = CGRectMake(kScreenWidth-66, naviHeight, 59, 41);
//        UILabel *zheLb = [[UILabel alloc] init];
//        zheLb.text = @"元";
//        zheLb.font = [UIFont systemFontOfSize:13];
//        zheLb.textColor = [UIColor whiteColor];
//        [_vipBgImage addSubview:zheLb];
//        
//        [zheLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vipBgImage.mas_top).offset(13);
//            make.right.equalTo(self.vipBgImage.mas_right).offset(-5);
//            make.height.mas_equalTo(13);
//        }];
//        self.discountLb = [[UILabel alloc]initWithFrame:CGRectMake(23, 5, 27, 25)];
//        self.discountLb.textColor = [UIColor whiteColor];
//        
//        if (![Utils isBlankString:self.model.vipRebatePrice]) {
//            self.discountLb.text = [NSString stringWithFormat:@"%.2f",[self.model.vipRebatePrice doubleValue]];
//        }
//        
//        self.discountLb.font = [UIFont fontWithName:impactCh size:19];
//        [_vipBgImage addSubview:self.discountLb];
//        
//        [self.discountLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vipBgImage.mas_top).offset(5);
//            make.right.equalTo(zheLb.mas_left).offset(-2);
//            make.height.mas_equalTo(23);
//        }];
//        
//        UILabel *vipSign = [[UILabel alloc] init];
//        vipSign.text = @"会员立减";
//        vipSign.font = [UIFont systemFontOfSize:13];
//        vipSign.textColor = [UIColor whiteColor];
//        [_vipBgImage addSubview:vipSign];
//        
//        [vipSign mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(zheLb.mas_bottom).offset(1);
//            make.right.equalTo(self.vipBgImage.mas_right).offset(-5);
//            make.height.mas_equalTo(13);
//        }];
    }
    return _vipBgImage;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    
    
}
#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
}
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != _cycleScrollView) {
        return nil;
    }
    return [goodsDetailHeadCell class];
}
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    goodsDetailHeadCell *myCell = (goodsDetailHeadCell *)cell;
    myCell.goodsImageUrl = self.shufflingArray[index];
    
    
    if (index == 0) {
        myCell.signImage.hidden = NO;
        if ([Utils isBlankString:self.model.vipRebatePrice]) {
            myCell.signImage.hidden = YES;
        }else {
            myCell.discountLb.text = [NSString stringWithFormat:@"%.2f",[self.model.vipRebatePrice doubleValue]];
            if ([self.model.vipRebatePrice doubleValue] == 0) {
                myCell.signImage.hidden = YES;
            }
        }
    }else {
        myCell.signImage.hidden = YES;
    }
    
}
- (void)setModel:(shoppingCartModel *)model {
    _model = model;
}
#pragma mark - Setter Getter Methods
- (void)setShufflingArray:(NSArray *)shufflingArray
{
    _shufflingArray = shufflingArray;
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    if ([_isHaveVideo isEqualToString:@"1"]) {
        
        self.detailsV = [[LZProductDetails alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
        self.detailsV.isHaveVideo = @"1";
        self.detailsV.goodsPreview = self.goodsPreview;
        [self addSubview:self.detailsV];
        
        self.detailsV.scrollOptBlock = ^(NSInteger index) {
            NSLog(@"第%d页",(int)index);
        };
        self.detailsV.PlayVideoOptBlock = ^(BOOL isOK) {
            NSLog(@"点击播放");
        };
        if ([Utils isBlankString:self.model.vipRebatePrice]) {
            [self.detailsV updateUIWithImageAndVideoArray:_shufflingArray vipSignImage:nil];
        }else {
            
            if ([self.model.vipRebatePrice doubleValue] == 0) {
                [self.detailsV updateUIWithImageAndVideoArray:_shufflingArray vipSignImage:nil];
            }else {
                [self.detailsV updateUIWithImageAndVideoArray:_shufflingArray vipSignImage:self.vipBgImage];
            }
        }
        

    } else {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) delegate:self placeholderImage:[UIImage imageNamed:@"goodss"]];
        _cycleScrollView.autoScroll = NO; // 不自动滚动
        
        [self addSubview:_cycleScrollView];
        _cycleScrollView.imageURLStringsGroup = shufflingArray;
        _cycleScrollView.firstImageUrl = shufflingArray[0];
    }
    
}
- (void)setIsHaveVideo:(NSString *)isHaveVideo {
    _isHaveVideo = isHaveVideo;
}
- (void)setGoodsPreview:(NSString *)goodsPreview {
    _goodsPreview = goodsPreview;
}
@end
