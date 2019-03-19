//
//  searchHotTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^returnHotHeight) (CGFloat height);
typedef void (^returnHotStr) (NSString *hotStr);
@interface searchHotTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *buttonArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) returnHotHeight heightBlock;
@property (nonatomic, copy) returnHotStr hotBlock;
@end
