//
//  categoryCollectionViewCell.h
//  Distribution
//
//  Created by hchl on 2018/11/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface categoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@end

NS_ASSUME_NONNULL_END
