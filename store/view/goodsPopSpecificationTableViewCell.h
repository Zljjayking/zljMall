//
//  goodsPopSpecificationTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
typedef void (^returnHeight) (CGFloat height);
typedef void (^returnSpecification) (GoodsCategoryModel *model);
@interface goodsPopSpecificationTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *buttonArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *selectID;
@property (nonatomic, copy) returnHeight heightBlock;
@property (nonatomic, copy) returnSpecification specificationBlock;
@end
