//
//  refundInfoTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface refundInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *isshelfLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsModelLb;
@property (weak, nonatomic) IBOutlet UILabel *refundReasonLb;
@property (weak, nonatomic) IBOutlet UILabel *refundMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *applyCountLb;
@property (weak, nonatomic) IBOutlet UILabel *refundNumLb;

@property (nonatomic, strong) orderModel *model;

@end

NS_ASSUME_NONNULL_END
