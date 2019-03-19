//
//  orderGoodsTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
#import "orderModel.h"

typedef void (^refundBtnBlock)(void);
typedef void (^logisticBtnBlock)(void);
@interface orderGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsModelLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLb;
@property (weak, nonatomic) IBOutlet UILabel *isShelfLb;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIButton *logisticsBtn;
@property (weak, nonatomic) IBOutlet UILabel *refundStateLb;

@property (nonatomic, strong) shoppingCartModel *model;
@property (nonatomic, strong) orderModel *ordermodel;
@property (nonatomic, copy) refundBtnBlock refundBlock;
@property (nonatomic, copy) logisticBtnBlock logisticBlock;
@end
