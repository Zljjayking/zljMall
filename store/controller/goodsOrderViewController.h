//
//  goodsOrderViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"

@interface goodsOrderViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSArray *goodsArr;//准备生成订单的商品数组
@property (nonatomic, assign) NSInteger type;//1.从购物车购买。 2.直接在商品详情购买
@property (nonatomic, strong) NSString *shoppingCardId;//从购物车购买
@property (nonatomic, assign) BOOL isGroup;//是否拼团是 1.是  0.否
@property (nonatomic, assign) BOOL isHead;//是否是开团 1.开团 0.参团
@property (nonatomic, strong) NSString *groupId;//参团用到的groupId
@end
