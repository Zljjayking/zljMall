//
//  microGoodsTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/12/21.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^shareGoodsBlock)(void);
typedef void(^selectGoodsBlock)(shoppingCartModel *model);
@interface microGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipBgImage;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, copy) shareGoodsBlock shareBlock;
@property (nonatomic, copy) selectGoodsBlock selectBlcok;
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@end

NS_ASSUME_NONNULL_END
