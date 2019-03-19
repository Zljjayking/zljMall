//
//  refundInstructionTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface refundInstructionTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLb;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;

@end

NS_ASSUME_NONNULL_END
