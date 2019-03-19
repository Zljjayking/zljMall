//
//  refundApplyViewController.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "orderModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^refreshMyOrderListBlock)(void);
@interface refundApplyViewController : fenXiaoBaseViewController
@property (nonatomic, strong) orderModel *model;
@property (nonatomic, assign) NSInteger fromWhere;//1.从订单详情页 2.从申请详情修改 3.修改申请
@property (nonatomic, assign) NSInteger type;//1.退货退款  2.仅退款  3.修改申请
@property (nonatomic, copy) refreshMyOrderListBlock refreshBlock;
@end

NS_ASSUME_NONNULL_END
