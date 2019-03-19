//
//  categoryView.m
//  Distribution
//
//  Created by hchl on 2018/11/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "categoryView.h"
#import "categoryCollectionViewCell.h"
@implementation categoryView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = myWhite;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, self.height) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.backgroundColor = myWhite;
    collectionV.showsVerticalScrollIndicator = NO;
    [collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionV registerNib:[UINib nibWithNibName:@"categoryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"categoryCollectionViewCell"];
    [self addSubview:collectionV];
    self.collectionV = collectionV;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    categoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = RGB(246, 246, 246);
    categoryModel *model = self.categoryArr[indexPath.row];
    cell.selectImage.hidden = YES;
    cell.titleLb.text = model.categoryName;
    cell.titleLb.textColor = RGB(50, 50, 50);
    if (self.selectIndex == indexPath.row) {
        cell.backgroundColor = RGB(242, 247, 254);
        cell.selectImage.hidden = NO;
        cell.titleLb.textColor = myBlueType;
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//9宫格组
        return CGSizeMake((kScreenWidth-30)/2.0 , 45);
    }
    return CGSizeZero;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
}
- (void)setCategoryArr:(NSArray *)categoryArr {
    _categoryArr = categoryArr;
    [self.collectionV reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
