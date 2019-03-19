//
//  orderDetailFootTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fuzhiBtnBlock)(void);
@interface orderDetailFootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIDLb;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLb;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLb;
@property (weak, nonatomic) IBOutlet UIButton *fuzhiBtn;
@property (nonatomic, copy) fuzhiBtnBlock fuzhiBlock;

@end
