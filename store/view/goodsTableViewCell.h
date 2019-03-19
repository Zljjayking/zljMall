//
//  goodsTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
typedef void(^shareGoodsBlock)(void);

@interface goodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipBgImage;

@property (nonatomic, copy) shareGoodsBlock shareBlock;
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@end
