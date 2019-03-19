//
//  spellSubViewController.h
//  Distribution
//
//  Created by hchl on 2018/12/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"
#import "shoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^completeBlock)(void);
typedef void(^tableViewSelectBlock)(shoppingCartModel *model);
@interface spellSubViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSString *goodsCategoryId;
@property (nonatomic, copy) tableViewSelectBlock selectBlock;
@property (nonatomic, copy) completeBlock complete;
- (void)refrshDataComplete:(void(^)(void))complete;

@end

NS_ASSUME_NONNULL_END
