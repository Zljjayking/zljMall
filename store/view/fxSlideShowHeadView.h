//
//  fxSlideShowHeadView.h
//  Distribution
//
//  Created by hchl on 2018/7/23.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bannerClickBlock)(NSInteger index);
typedef void(^subButtonClickBlock)(NSInteger index);
@interface fxSlideShowHeadView : UICollectionReusableView
/* 轮播图数组 */
@property (copy , nonatomic)NSArray *imageGroupArray;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, copy) bannerClickBlock bannerBlock;
@property (nonatomic, copy) subButtonClickBlock subButtonBlock;
@end
