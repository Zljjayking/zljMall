//
//  logisticsInfoViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"

@interface logisticsInfoViewController : fenXiaoBaseViewController
@property (nonatomic, assign) NSInteger type;//1.从订单详情进入   2.从订单列表进入
@property (nonatomic, strong) NSArray *logisticArr;
@property (nonatomic, strong) NSString *logistic_no;
@property (nonatomic, strong) NSString *logistic_name;
@property (nonatomic, strong) NSString *logisticCode;
@end
