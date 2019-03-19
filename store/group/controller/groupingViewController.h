//
//  groupingViewController.h
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "shoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface groupingViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSString *groupId;//拼团的gorupId
@property (nonatomic, assign) NSInteger type;//1.从购买进来   2.从我的进来
@property (nonatomic, strong) NSString *goodsPreview;//商品图片
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@end

NS_ASSUME_NONNULL_END
