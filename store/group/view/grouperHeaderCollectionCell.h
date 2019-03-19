//
//  grouperHeaderCollectionCell.h
//  Distribution
//
//  Created by hchl on 2018/12/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface grouperHeaderCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *signImage;
@property (nonatomic, strong) groupingModel *groupModel;
@end

NS_ASSUME_NONNULL_END
