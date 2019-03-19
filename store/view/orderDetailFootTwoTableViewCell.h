//
//  orderDetailFootTwoTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/30.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fuzhiBtnClickBlock)(void);
@interface orderDetailFootTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIDLb;
@property (weak, nonatomic) IBOutlet UIButton *fuzhiBtn;
@property (nonatomic, copy) fuzhiBtnClickBlock fuzhiBlock;
@end
