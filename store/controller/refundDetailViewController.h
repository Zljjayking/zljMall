//
//  refundDetailViewController.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "orderModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^modifyFromApplyViewBlcok)(orderModel *model);
typedef void(^refreshTopViewBlock)(void);//用来刷新上层view
@interface refundDetailViewController : fenXiaoBaseViewController
@property (nonatomic, strong) orderModel *model;
@property (nonatomic, assign) NSInteger fromWhere;//1.从申请界面  2.从订单详情页
@property (nonatomic, assign) NSInteger type;//1待处理 2.已同意待填物流 3.已同意待退款 4.退款成功 5.已撤销 6.已拒绝 7.失败 新加（2、待退货 3、退货中）

@property (nonatomic, copy) refreshTopViewBlock refreshBlock;
@property (nonatomic, copy) modifyFromApplyViewBlcok modifyBlock;
@end

NS_ASSUME_NONNULL_END
