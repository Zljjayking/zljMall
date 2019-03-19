//
//  removeHistoryTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^removeBtnClick)(void);

@interface removeHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *removeHistoryBtn;
@property (nonatomic, copy) removeBtnClick block;
@end
