//
//  groupingHeaderView.h
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupingModel.h"
#import "shoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^shareGroupBlock)(shoppingCartModel *goodsModel);
@interface groupingHeaderView : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *spellHeaderImageV;
@property (weak, nonatomic) IBOutlet UILabel *spellHeaderNameLb;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;

@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIImageView *spellGoodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *groupNumLb;

@property (weak, nonatomic) IBOutlet UILabel *leftOneLb;
@property (weak, nonatomic) IBOutlet UILabel *leftTwoLb;
@property (weak, nonatomic) IBOutlet UILabel *leftThreeLb;
@property (weak, nonatomic) IBOutlet UILabel *leftFourLb;
@property (weak, nonatomic) IBOutlet UILabel *hourLb;
@property (weak, nonatomic) IBOutlet UILabel *minuteLb;

@property (weak, nonatomic) IBOutlet UILabel *timeOneLb;
@property (weak, nonatomic) IBOutlet UILabel *timeTwoLb;
@property (weak, nonatomic) IBOutlet UILabel *timeThreeLb;
@property (weak, nonatomic) IBOutlet UICollectionView *grouperCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) groupingModel *groupModel;
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@property (nonatomic, assign) BOOL isGrouped;//是否成团
@property (nonatomic, strong) NSArray *grouperArr;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) shareGroupBlock shareBlock;
@end

NS_ASSUME_NONNULL_END
