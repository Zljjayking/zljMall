//
//  fxGoodsPopView.h
//  Distribution
//
//  Created by hchl on 2018/7/31.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"

typedef void (^isPop)(void);
typedef void (^addToCart)(shoppingCartModel *model);
typedef void (^tapBlank) (shoppingCartModel *model);
typedef void (^toBuyBlock)(shoppingCartModel *model);

@interface fxGoodsPopView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *specificationArray;
@property (nonatomic, strong) shoppingCartModel *model;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) isPop isPopBlock;
@property (nonatomic, copy) addToCart addToCartBlcok;
@property (nonatomic, copy) tapBlank tapBlankBlock;
@property (nonatomic, copy) toBuyBlock buyBlock;

/**
 isShowSign 是否显示图片下面的说明 1是 0 否
 signText 说明的文字
 */
- (fxGoodsPopView *)initWithCatetory:(NSArray *)array model:(shoppingCartModel *)model height:(CGFloat)height title:(NSString *)title superView:(UIView *)superView isShowSign:(BOOL)isShowSign signText:(NSString *)signText;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat cellOneheight;
@property (nonatomic, strong) NSString *specification;//规格的字符串
@property (nonatomic, strong) NSString *goodsCount;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, assign) BOOL isShowSign;
@property (nonatomic, strong) NSString *signText;
@property (nonatomic, strong) NSString *title;
@end
