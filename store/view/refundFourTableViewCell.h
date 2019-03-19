//
//  refundFourTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
//#imp
NS_ASSUME_NONNULL_BEGIN

@interface refundFourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logisticsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *logisticsDetailLb;
@property (weak, nonatomic) IBOutlet UIButton *cancelApplyBtn;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *logisticTimeLb;

@end

NS_ASSUME_NONNULL_END
