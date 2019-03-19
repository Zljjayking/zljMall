//
//  searchHeaderView.h
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBtnIndex)(NSInteger index,BOOL paiXu);

@interface searchHeaderView : UIView
@property (nonatomic, copy) returnBtnIndex block;
@property (nonatomic, strong) UIButton *synthesizeBtn;
@property (nonatomic, strong) UIButton *volumeBtn;
@property (nonatomic, strong) UIButton *priceBtn;
@property (nonatomic, strong) UIButton *returnBtn;
@property (nonatomic, strong) UIView *lineV;
//排序的图片
@property (nonatomic, strong) UIImageView *priceImageOne;
@property (nonatomic, strong) UIImageView *priceImageTwo;
@property (nonatomic, strong) UIImageView *returnImageOne;
@property (nonatomic, strong) UIImageView *returnImageTwo;

@property (nonatomic, assign) NSInteger index;//选中的index
@property (nonatomic, assign) BOOL isAscending;//是否升序
@end
