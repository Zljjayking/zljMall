//
//  microGoodsTableCell.h
//  Distribution
//
//  Created by hchl on 2018/12/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "shoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^shareBtnClickBlock)(void);
typedef void(^selectGoodsBlock)(shoppingCartModel *model);
@interface microGoodsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *groupCountLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLb;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipBgImage;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@property (nonatomic, strong) shoppingCartModel *goodsModel;
@property (nonatomic, copy) shareBtnClickBlock shareBlock;
@property (nonatomic, copy) selectGoodsBlock selectBlcok;
@end

NS_ASSUME_NONNULL_END
