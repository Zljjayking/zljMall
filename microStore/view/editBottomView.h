//
//  editBottomView.h
//  Distribution
//
//  Created by hchl on 2018/12/21.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectAllBtnBlock)(BOOL isSelect);
typedef void(^editBtnBlock)(NSInteger btnIndex);
@interface editBottomView : UIView
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *removeBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, copy) selectAllBtnBlock selectAllBlock;
@property (nonatomic, copy) editBtnBlock editBlock;
@end

NS_ASSUME_NONNULL_END
