//
//  goodsInfoCollectionCell.h
//  Distribution
//
//  Created by hchl on 2018/12/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^shareGoodsBtnBlock)(void);
@interface goodsInfoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *spellNumLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailsLb;
@property (weak, nonatomic) IBOutlet UILabel *expressageLb;
@property (weak, nonatomic) IBOutlet UILabel *salesVolumeLb;
@property (weak, nonatomic) IBOutlet UIButton *shareGoodsBtn;
@property (nonatomic, strong) UILabel *groupNumLb;
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@property (nonatomic, copy) shareGoodsBtnBlock shareBlock;
@end

NS_ASSUME_NONNULL_END
