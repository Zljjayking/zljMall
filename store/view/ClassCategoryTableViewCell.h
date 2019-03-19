//
//  ClassCategoryTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassGoodsItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassCategoryTableViewCell : UITableViewCell
/* 标题数据 */
@property (strong , nonatomic)ClassGoodsItem *titleItem;

@property (nonatomic, assign) BOOL isSelect;
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 指示View */
@property (strong , nonatomic)UIView *indicatorView;
@end

NS_ASSUME_NONNULL_END
