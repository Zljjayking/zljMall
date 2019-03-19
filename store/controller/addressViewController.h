//
//  addressViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/6.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "addressModel.h"
typedef void(^returnAddressModelBlock)(addressModel *model);

@interface addressViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, copy) returnAddressModelBlock addressModelBlock;

@end
