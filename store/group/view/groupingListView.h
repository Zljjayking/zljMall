//
//  groupingListView.h
//  Distribution
//
//  Created by hchl on 2018/12/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "spellModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^joinClickBlock)(spellModel *model);
typedef void(^closeBtnClick)(void);
@interface groupingListView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(instancetype)initWithFrame:(CGRect)frame goodsID:(NSString *)goodsID userId:(NSString *)userId joinClick:(void(^)(spellModel *model))joinClick;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *groupListArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, copy) joinClickBlock joinBlock;
@property (nonatomic, copy) closeBtnClick closeBtnClickBlock;
@property (nonatomic, strong) NSMutableSet *set;
- (void)cancelTimer;
@end

NS_ASSUME_NONNULL_END
