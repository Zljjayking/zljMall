//
//  refundDetailTwoTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^refundCancelBlock)(void);
typedef void(^refundModifyBlock)(void);
@interface refundDetailTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *OnePointView;
@property (weak, nonatomic) IBOutlet UIView *twoPointView;
@property (weak, nonatomic) IBOutlet UILabel *oneLb;
@property (weak, nonatomic) IBOutlet UILabel *twoLb;

@property (nonatomic, copy) refundCancelBlock cancelBlock;
@property (nonatomic, copy) refundModifyBlock modifyBlock;
@end

NS_ASSUME_NONNULL_END
