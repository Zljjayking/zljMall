//
//  orderSiteTwoTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"
@interface orderSiteTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UIImageView *seperatorImage;
@property (nonatomic, strong) addressModel *address;
@end
