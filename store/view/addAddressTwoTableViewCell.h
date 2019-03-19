//
//  addAddressTwoTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/8.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addAddressTwoTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLb;

@end
