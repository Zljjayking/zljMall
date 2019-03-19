//
//  groupingListView.m
//  Distribution
//
//  Created by hchl on 2018/12/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "groupingListView.h"
#import "groupingCollectionTwoCell.h"
@implementation groupingListView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = myWhite;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"groupingCollectionTwoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"groupingCollectionTwoCell"];
    }
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame goodsID:(NSString *)goodsID userId:(NSString *)userId joinClick:(nonnull void (^)(spellModel * _Nonnull))joinClick{
    self = [super initWithFrame:frame];
    if (self) {
        if (self) {
            self.clipsToBounds = YES;
            self.backgroundColor = myWhite;
            self.set = [NSMutableSet set];
            _goodsID = goodsID;
            _userId = userId;
            _joinBlock = joinClick;
            self.groupListArr = @[].mutableCopy;
            [self requestData];
            [self setUpUI];
        }
    }
    return self;
}

- (void)setUpUI {
    self.collectionView.frame = CGRectMake(0, 41, self.width, self.height-41);
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self requestData];
    }];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, self.width, 16)];
    titleLb.text = @"正在拼团";
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLb];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, 0.6)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:line];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.width-40, 5, 30, 30);
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.collectionView];
}
- (void)closeBtnClick {
    if (self.closeBtnClickBlock) {
        self.closeBtnClickBlock();
    }
}
- (void)requestData {
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    NSDictionary *parameter = @{@"goodsId":self.goodsID,@"userId":self.userId,@"page":page,@"size":@"10"};
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:queryInProgressPTUrl parameters:parameter progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *message = dataDic[@"message"];
            [self.collectionView.mj_footer endRefreshing];
            if ([code isEqualToString:@"200"]) {
                NSArray *dataArr = dataDic[@"data"];
                if ([dataArr isKindOfClass:[NSArray class]]) {
                    if (dataArr.count) {
                        self.groupListArr = [spellModel mj_objectArrayWithKeyValuesArray:dataArr];
                        if (dataArr.count < 10) {
                            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                        }
                    }
                    
                    [self.collectionView reloadData];
                }else {
                    
                }
            }else {
                [MBProgressHUD showError:message toView:self];
            }
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self];
    }];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupListArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    groupingCollectionTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupingCollectionTwoCell" forIndexPath:indexPath];
    [self.set addObject:indexPath];
    if (self.groupListArr.count) {
        spellModel *model = self.groupListArr[0];
        cell.spellmodel = model;
        cell.joinBlock = ^(spellModel * _Nonnull model) {
            if (model) {
                if (self.joinBlock) {
                    self.joinBlock(model);
                }
            }
        };
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(340*KAdaptiveRateWidth, 75);
}
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}
#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark -
#pragma mark -UIScrollView delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//                  willDecelerate:(BOOL)decelerate {
//    NSSet *visiblecells = [NSSet setWithArray:[self.collectionView indexPathsForVisibleItems]];
//    [self.set minusSet:visiblecells];
//
//    for (NSIndexPath *anIndexPath in self.set) {
//        groupingCollectionTwoCell *cell = (groupingCollectionTwoCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"groupingCollectionTwoCell" forIndexPath:anIndexPath];
//        if (cell) {
//            dispatch_source_cancel(cell.timer);
//        }
//    }
//}
//- (void)cancelTimer {
//    for (NSIndexPath *anIndexPath in self.set) {
//        groupingCollectionTwoCell *cell = (groupingCollectionTwoCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"groupingCollectionTwoCell" forIndexPath:anIndexPath];
//        if (cell) {
//            dispatch_source_cancel(cell.timer);
//        }
//    }
//}
@end
