//
//  editAddressViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/7.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "addressModel.h"

typedef void(^refreshAddressBlock)(void);

@interface editAddressViewController : fenXiaoBaseViewController
@property (nonatomic, strong) addressModel *model;
@property (nonatomic, assign) NSInteger type;//1.新增收获地址   2.修改收货地址
@property (nonatomic, copy) refreshAddressBlock refreshBlcok;
@end
