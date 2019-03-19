//
//  paySuccessViewController.h
//  Distribution
//
//  Created by hchl on 2018/8/10.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fenXiaoBaseViewController.h"

typedef void(^BtnClickBlock)(NSInteger leftOrRight);//1 是左 2 是右

@interface paySuccessViewController : fenXiaoBaseViewController
@property (nonatomic, strong) NSString *imageTitle;
@property (nonatomic, strong) NSString *selfTitle;
@property (nonatomic, strong) NSString *operation;
@property (nonatomic, strong) NSString *subTitleOne;
@property (nonatomic, strong) NSString *subTitleTwo;
@property (nonatomic, strong) NSString *leftBtnTitle;
@property (nonatomic, strong) NSString *rightBtnTitle;
@property (nonatomic, copy) BtnClickBlock btnBlock;
@end
