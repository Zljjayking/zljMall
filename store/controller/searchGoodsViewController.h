//
//  searchGoodsViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"

@interface searchGoodsViewController : fenXiaoBaseViewController
@property (nonatomic, assign) NSInteger type;//3.从分类点击进来 4.从精选点击进来
@property (nonatomic, strong) NSString *categoryId;
@end
