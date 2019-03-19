//
//  goodsDetailHeadCell.h
//  Distribution
//
//  Created by hchl on 2018/12/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface goodsDetailHeadCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UIImageView *signImage;
@property (nonatomic, strong) UILabel *discountLb;

@property (nonatomic, strong) NSString *goodsImageUrl;
@property (nonatomic, strong) NSString *discount;
@end

NS_ASSUME_NONNULL_END
