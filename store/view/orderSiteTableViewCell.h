//
//  orderSiteTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"
@interface orderSiteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;
@property (weak, nonatomic) IBOutlet UILabel *defaultLb;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UIImageView *seperatorImage;
@property (nonatomic, strong) addressModel *address;
@end
