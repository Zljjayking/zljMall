//
//  refundLogisticsViewController.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "orderModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^fillInCompleteBlock)(orderModel *model);
@interface refundLogisticsViewController : fenXiaoBaseViewController
@property (nonatomic, strong) orderModel *model;
@property (nonatomic, copy) fillInCompleteBlock completeBlock;

@end

NS_ASSUME_NONNULL_END
