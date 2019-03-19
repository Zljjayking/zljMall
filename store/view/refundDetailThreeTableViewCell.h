//
//  refundDetailThreeTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^fillInBtnClickBlock)(void);
@interface refundDetailThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *consigneeLb;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UIButton *fillInBtn;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic, copy) fillInBtnClickBlock fillInBtnBlock;
@end

NS_ASSUME_NONNULL_END
