//
//  categoryGoodsViewController.h
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^subClassClickBlock)(id object);
@interface categoryGoodsViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) subClassClickBlock subClassBlock;
- (void)reloadDataWithDataArr:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
