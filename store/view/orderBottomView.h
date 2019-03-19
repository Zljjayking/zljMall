//
//  orderBottomView.h
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^submitBlcok)(void);

@interface orderBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, copy) submitBlcok submitblock;
@end
