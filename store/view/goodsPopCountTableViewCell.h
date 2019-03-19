//
//  goodsPopCountTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^goodsCountChange)(void);
@interface goodsPopCountTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,retain)UILabel *numberLabel;
@property (nonatomic,copy)goodsCountChange numAddBlock;
@property (nonatomic,copy)goodsCountChange numCutBlock;
@end
