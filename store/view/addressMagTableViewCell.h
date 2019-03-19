//
//  addressMagTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/6.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

typedef void(^setDefaultBlock)(BOOL isDefault);
typedef void(^editBtnBlock)(void);
@interface addressMagTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (nonatomic, copy) setDefaultBlock defaultBlcok;
@property (nonatomic, copy) editBtnBlock editBlock;
@property (nonatomic, strong) addressModel *model;
@end
