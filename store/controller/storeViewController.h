//
//  storeViewController.h
//  Distribution
//
//  Created by hchl on 2018/7/23.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "ADView.h"
#import "ADViewController.h"
@interface storeViewController : fenXiaoBaseViewController<LFAdViewDelegate>
@property (nonatomic, assign) NSInteger fromWhere;
@end
