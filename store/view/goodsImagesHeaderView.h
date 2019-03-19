//
//  goodsImagesHeaderView.h
//  Distribution
//
//  Created by hchl on 2018/7/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZProductDetails.h"
#import "shoppingCartModel.h"
@interface goodsImagesHeaderView : UICollectionReusableView
/** 轮播数组 */
@property (nonatomic, copy) NSArray *shufflingArray;
@property (nonatomic, strong) NSString *isHaveVideo;
@property (strong , nonatomic)LZProductDetails *detailsV;
@property (strong, nonatomic) NSString *goodsPreview;
@property (nonatomic, strong) shoppingCartModel *model;
@end
