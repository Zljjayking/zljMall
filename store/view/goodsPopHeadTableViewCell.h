//
//  goodsPopHeadTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsPopHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *repertoryLb;
@property (weak, nonatomic) IBOutlet UILabel *modelLb;
@property (weak, nonatomic) IBOutlet UILabel *signLb;

@end
