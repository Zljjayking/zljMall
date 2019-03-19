//
//  googsInfoViewController.h
//  Distribution
//
//  Created by hchl on 2018/7/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "shoppingCartModel.h"
typedef void(^refreshShoppingCart)(void);

@interface googsInfoViewController : fenXiaoBaseViewController
@property (nonatomic, assign) NSInteger fromWhere;//判断从哪里进入。1.购物车 0.其他
@property (nonatomic, copy) refreshShoppingCart refreshBlock;//刷新购物车
@property (nonatomic, strong) shoppingCartModel *model;
@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *goodsPreview;
@property (nonatomic, assign) BOOL isGroup;//是否是拼团的商品
@end
