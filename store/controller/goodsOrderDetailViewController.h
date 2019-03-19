//
//  goodsOrderDetailViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"

typedef void(^refreshMyOrderBlcok)(void);

@interface goodsOrderDetailViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, assign) NSInteger type;//1.从商城进来   2.从我的进来  3.从拼团进来
@property (nonatomic, copy) refreshMyOrderBlcok refreshBlock;
@property (nonatomic, assign) BOOL isHideBottom;
@end
