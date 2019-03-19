//
//  shoppingCartTableViewCell.h
//  Distribution
//
//  Created by hchl on 2018/7/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
typedef void(^fxCartBlock)(BOOL select);
typedef void (^fxNumChange)(void);
@interface shoppingCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *subsractBtn;
@property (weak, nonatomic) IBOutlet UILabel *isNotWorkLb;
@property (nonatomic, strong) shoppingCartModel *model;
@property (nonatomic,copy) fxCartBlock cartBlock;
@property (nonatomic,copy)fxNumChange numAddBlock;
@property (nonatomic,copy)fxNumChange numCutBlock;
@end
