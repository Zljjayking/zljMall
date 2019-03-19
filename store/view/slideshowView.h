//
//  slideshowView.h
//  Distribution
//
//  Created by hchl on 2018/12/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^bannerClickBlock)(NSInteger index);
@interface slideshowView : UIView
/* 轮播图数组 */
@property (copy , nonatomic)NSArray *imageGroupArray;
@property (nonatomic, copy) bannerClickBlock bannerBlock;
@end

NS_ASSUME_NONNULL_END
