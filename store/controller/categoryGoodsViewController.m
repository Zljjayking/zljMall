//
//  categoryGoodsViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "categoryGoodsViewController.h"
#import "ClassGoodsItem.h"
#import "categoryGoodsCell.h"
@interface categoryGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/* collectionViw */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray<ClassSubItem *> *mainItem;
@end

@implementation categoryGoodsViewController
/** 常量数 */
CGFloat const DCMargin = 10;

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = CGRectMake(0, 0, self.view.width, kScreenHeight);
        //注册Cell
        [_collectionView registerClass:[categoryGoodsCell class] forCellWithReuseIdentifier:@"categoryGoodsCell"];
//        [_collectionView registerClass:[DCBrandSortCell class] forCellWithReuseIdentifier:DCBrandSortCellID];
        //注册Header
//        [_collectionView registerClass:[DCBrandsSortHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCBrandsSortHeadViewID];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = FXBGColor;
    [self.view addSubview:self.collectionView];
}
#pragma mark - <UITableViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 20;
    return self.goodsArr.count;
    
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassSubItem *subItem = self.goodsArr[indexPath.row];
    
    categoryGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryGoodsCell" forIndexPath:indexPath];
    
    cell.subItem = subItem;
    return cell;
    
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.width - 6 - DCMargin)/3, (self.view.width - 6 - DCMargin)/3 + 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassSubItem *subItem = self.goodsArr[indexPath.row];
    if (self.subClassBlock) {
        self.subClassBlock(subItem);
    }
}
- (void)reloadDataWithDataArr:(NSArray *)arr {
    self.collectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.collectionView reloadData];
}

- (void)setGoodsArr:(NSArray *)goodsArr {
    _goodsArr = goodsArr;
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
