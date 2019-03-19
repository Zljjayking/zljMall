//
//  goodsInfoCollectionViewCell.h
//  Distribution
//
//  Created by hchl on 2018/7/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shareGoodsBtnBlock)(void);
@interface goodsInfoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareGoodsBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailsLb;
@property (weak, nonatomic) IBOutlet UILabel *expressageLb;
@property (weak, nonatomic) IBOutlet UILabel *salesVolumeLb;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UILabel *vipRebateLb;

@property (nonatomic, copy) shareGoodsBtnBlock shareBlock;
@end
