//
//  hotGoodsCollectionViewCell.h
//  Distribution
//
//  Created by hchl on 2018/7/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^shareBtnClickBlock)(void);
@interface hotGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipBgImage;
@property (nonatomic, copy) shareBtnClickBlock shareBlock;
@end
