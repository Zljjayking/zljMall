//
//  categoryView.h
//  Distribution
//
//  Created by hchl on 2018/11/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "categoryModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^selectCategoryBlcok)(NSInteger index);
@interface categoryView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *categoryArr;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, copy) selectCategoryBlcok selectBlock;
@end

NS_ASSUME_NONNULL_END
