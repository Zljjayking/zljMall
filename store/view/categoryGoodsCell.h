//
//  categoryGoodsCell.h
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassGoodsItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface categoryGoodsCell : UICollectionViewCell

@property (strong , nonatomic)ClassSubItem *subItem;
/* imageView */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* label */
@property (strong , nonatomic)UILabel *goodsTitleLabel;
@end

NS_ASSUME_NONNULL_END
